<template>
  <div class="address-box">
<!--    name的值表示了显示在顶部的文字，back通过判断是不是创建来自于订单界面，从而选择其返回路径-->

    <s-header :name="'地址管理'" :back="state.from == 'create-order' ? '' : '/user'"></s-header>
    <div class="address-item">
<!--      将 state.list 绑定到 <van-address-list> 组件的 list 属性，传递地址列表数据给组件进行展示。-->
      <!--      使用冒号 : 表示将属性值绑定为JavaScript表达式，也就是动态绑定属性。-->
<!--      default-tag-text用于表示默认flag中显示的文字-->
<!--  监听 <van-address-list> 组件的 add 事件，并在触发事件时调用 onAdd 方法。这表示当用户点击添加地址按钮时，将会执行 onAdd 函数。-->
<!--      监听 <van-address-list> 组件的 edit 事件，并在触发事件时调用 onEdit 方法。这表示当用户点击编辑地址按钮时，将会执行 onEdit 函数。-->
<!--      监听 <van-address-list> 组件的 select 事件，并在触发事件时调用 select 方法。这表示当用户选择某个地址时，将会执行 select 函数。-->
      <van-address-list
        v-if="state.from != 'mine'"
        v-model="state.chosenAddressId"
        :list="state.list"
        default-tag-text="默认"
        @add="onAdd"
        @edit="onEdit"
        @select="select"
      />
      <van-address-list
        v-else
        v-model="state.chosenAddressId"
        :list="state.list"
        default-tag-text="Default"
        @add="onAdd"
        @edit="onEdit"
      />
    </div>
  </div>
</template>
<script setup>
import { reactive, onMounted } from 'vue'
import sHeader from '@/components/SimpleHeader.vue'
import { getAddressList } from '@/service/address'
import { useRoute, useRouter } from 'vue-router'
const route = useRoute()
const router = useRouter()
/*reactive函数用于创建响应式对象。它接受一个普通的 JavaScript 对象作为参数，并返回一个与该对象具有相同属性的响应式代理对象。
* 一旦对象被转换为响应式对象，就可以在 Vue 组件中使用它的属性，并且当属性值发生改变时，相关的视图将会被自动更新。*/
const state = reactive({
  chosenAddressId: '1',
  list: [],
  /*route?.query?.from 是一种简化的写法，表示从 route 对象的 query 属性中获取 from 属性的值。
  如果 route 或 query 为 null 或 undefined，则返回 undefined。
  ?? 是空值合并运算符，表示如果前面的表达式结果为 null 或 undefined，则使用后面的值作为默认值。*/
  from: route?.query?.from ?? ''
})

onMounted(() => {
  init()
})

const init = async () => {
  const { data } = await getAddressList()
  if (!data) {
    state.list = []
    return
  }
  state.list = data.map(item => {
    return {
      id: item.addressId,
      name: item.userName,
      tel: item.userPhone,
      address: `${item.provinceName} ${item.cityName} ${item.regionName} ${item.detailAddress}`,
      isDefault: !!item.defaultFlag
    }
  })
}

// 前往添加地址页面
const onAdd = () => {
  router.push({ path: 'address-edit', query: { type: 'add', from: state.from  } })
}
// 前往地址编辑页面
const onEdit = (item) => {
  router.push({ path: 'address-edit', query: { type: 'edit', addressId: item.id, from: state.from  } })
}
// 选择某个地址后，跳回订单生成页面
const select = (item, index) => {
  router.push({ path: 'create-order', query: { addressId: item.id, from: state.from  } })
}
</script>

<style lang="less">
  @import '../common/style/mixin';
  .address-box {
    .van-radio__icon {
      display: none;
    }
    .address-item {
      .van-button {
        background: @primary;
        border-color: @primary;
      }
    }
  }
</style>
