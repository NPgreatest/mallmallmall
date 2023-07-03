<template>
  <div class="address-edit-box">
<!--冒号将name属性绑定到 s-header 组件，绑定一个JavaScript表达式到这个属性
这段代码的作用是根据 state.type 的值动态地设置 s-header 组件的名称。如果 state.type 等于 'add'，
s-header 的名称将是 '新增地址'；否则，名称将是 '编辑地址'。这在用户界面中可能是用来切换两种不同的模式（例如，添加地址模式和编辑地址模式）。
使用 ${}，可以在字符串中插入变量、表达式或者任何有效的 JavaScript 表达式，并且这个表达式的结果会被嵌入到最终的字符串中。-->
<!--    在这里如果state.type == 'add'那么就显示新增地址，否则显示编辑地址-->
    <s-header :name="`${state.type == 'add' ? '新增地址' : '编辑地址'}`"></s-header>
<!--将state.areaList动态绑定到area-list。area-list是地区列表，默认为-
    address-info是地址信息初始值，默认为{}
    show-delete决定是否显示删除按钮，默认为false
    show-set-default规定是否显示“设为默认收货地址”这一栏目
    -->
    <van-address-edit
      class="edit"
      :area-list="state.areaList"
      :address-info="state.addressInfo"
      :show-delete="state.type == 'edit'"
      show-set-default
      show-search-result
      :search-result="state.searchResult"
      :area-columns-placeholder="['请选择', '请选择', '请选择']"
      @save="onSave"
      @delete="onDelete"
    />
  </div>
</template>

<script setup>
import { reactive, onMounted } from 'vue'
import { showToast } from 'vant'
import sHeader from '@/components/SimpleHeader.vue'
import { addAddress, EditAddress, DeleteAddress, getAddressDetail } from '@/service/address'
/*引入所有的地址信息*/
import { tdist } from '@/common/js/utils'
import { useRoute, useRouter } from 'vue-router'
const route = useRoute()
const router = useRouter()
const state = reactive({
  areaList: {
    province_list: {},
    city_list: {},
    county_list: {}
  },
  searchResult: [],
  type: 'add',
  addressId: '',
  addressInfo: {},
  from: route.query.from
})

onMounted(async () => {
  // 这里通过循环进行了省市区列表的构造
  let _province_list = {}
  let _city_list = {}
  let _county_list = {}
  tdist.getLev1().forEach(p => {
    _province_list[p.id] = p.text
    tdist.getLev2(p.id).forEach(c => {
      _city_list[c.id] = c.text
      tdist.getLev3(c.id).forEach(q => _county_list[q.id] = q.text)
    })
  })
  state.areaList.province_list = _province_list
  state.areaList.city_list = _city_list
  state.areaList.county_list = _county_list
/*获取查询参数*/
  const { addressId, type, from } = route.query
  state.addressId = addressId
  state.type = type
  state.from = from || ''
  /*如果type是edit，那就代表可以编辑*/
  if (type == 'edit') {
    console.log(1)
    const { data: addressDetail } = await getAddressDetail(addressId)
    console.log(addressDetail)
    let _areaCode = ''
    const province = tdist.getLev1()
    /*Object.entries将state.areaList.county_list对象转换为一个包含键值对的数组，其中每个键值对表示一个区县的代码和名称。
    * */
    Object.entries(state.areaList.county_list).forEach(([id, text]) => {
      // 先找出当前对应的区
      if (text == addressDetail.regionName) {
        // 找到区对应的几个省份，几个区可能回重名
        const provinceIndex = province.findIndex(item => item.id.substr(0, 2) == id.substr(0, 2))
        // 找到区对应的几个市区
        /*filter() 方法会返回一个新的数组，其中包含满足条件的元素。*/
        const cityItem = Object.entries(state.areaList.city_list).filter(([cityId, cityName]) => cityId.substr(0, 4) == id.substr(0, 4))[0]
        console.log(cityItem)
        // 对比找到的省份和接口返回的省份是否相等，因为有一些区会重名
        /*foreach无法中途停止*/
        if (province[provinceIndex].text == addressDetail.provinceName && cityItem[1] == addressDetail.cityName) {
          _areaCode = id
        }
      }
    })



    state.addressInfo = {
      id: addressDetail.addressId,
      name: addressDetail.userName,
      tel: addressDetail.userPhone,
      province: addressDetail.provinceName,
      city: addressDetail.cityName,
      county: addressDetail.regionName,
      addressDetail: addressDetail.detailAddress,
      areaCode: _areaCode,
      isDefault: !!addressDetail.defaultFlag
    }
  }
})

const onSave = async (content) => {
  const params = {
    userName: content.name,
    userPhone: content.tel,
    provinceName: content.province,
    cityName: content.city,
    regionName: content.county,
    detailAddress: content.addressDetail,
    defaultFlag: content.isDefault ? 1 : 0,
  }
  if (state.type == 'edit') {
    params['addressId'] = state.addressId
  }
  await state.type == 'add' ? addAddress(params) : EditAddress(params)
  showToast('保存成功')
  setTimeout(() => {
    router.back()
  }, 1000)
}

const onDelete = async () => {
  await DeleteAddress(state.addressId)
  showToast('删除成功')
  setTimeout(() => {
    router.back()
  }, 1000)
}
</script>

<style lang="less">
  @import '../common/style/mixin';
  .edit {
    .van-field__body {
      textarea {
        height: 26px!important;
      }
    }
  }
  .address-edit-box {
    .van-address-edit {
      .van-button--danger {
        background: @primary;
        border-color: @primary;
      }
      .van-switch--on {
        background: @primary;
      }
    }
  }
</style>
