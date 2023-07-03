<template>
  <div class="address-box">
<!--    name的值表示了显示在顶部的文字，back通过判断是不是创建来自于订单界面，从而选择其返回路径-->
<!--如果state.from == 'create-order'那么是‘’ 如果是‘mine’那么是'/user'-->
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
/*useRoute 是 Vue Router 提供的一个函数，用于在组件中获取当前的路由对象。
* 通过调用 useRoute 函数，可以获得一个表示当前路由的 route 对象，其中包含了路由的各种信息，例如路径、参数、查询参数等。
* 在代码中，通过 const route = useRoute() 将当前的路由对象赋值给 route 变量，以便后续在组件中使用。*/
const route = useRoute()
/*useRouter 是 Vue Router 提供的一个函数，用于在组件中获取路由实例。
* 路由实例是一个 Vue Router 的核心对象，它提供了导航、跳转等路由相关的方法和属性。
* 通过调用 useRouter 函数，可以获得当前应用程序中的路由实例。*/
const router = useRouter()
/*reactive函数用于创建响应式对象。它接受一个普通的 JavaScript 对象作为参数，并返回一个与该对象具有相同属性的响应式代理对象。
* 一旦对象被转换为响应式对象，就可以在 Vue 组件中使用它的属性，并且当属性值发生改变时，相关的视图将会被自动更新。*/
const state = reactive({
  chosenAddressId: '1',
  /*list中储存了id,name,tel,address,isdefault*/
  list: [],
  /*route?.query?.from 是一种简化的写法，表示从 route 对象的 query 属性中获取 from 属性的值。
  如果 route 或 query 为 null 或 undefined，则返回 undefined。
  ?? 是空值合并运算符，表示如果前面的表达式结果为 null 或 undefined，则使用后面的值作为默认值。
  route.query 是 Vue Router 中的一个属性，用于获取当前路由的查询参数（Query Parameters）部分。*/
  from: route?.query?.from ?? ''
})
/*onMounted 是 Vue 3 中的一个钩子函数，用于在组件挂载后执行一些操作。
在这段代码中，通过 onMounted(() => { init() })，当组件挂载后会调用 init 函数进行初始化操作。*/
onMounted(() => {
  init()
})
/*ctrl寻踪getAddressList()可以看到其调用了axios库中的get函数，请求的 URL 是 /address，表示向服务器请求地址列表数据。
* 作为可选的第二个参数，传递了一个包含请求参数的对象 { pageNumber: 1, pageSize: 1000 }。这个对象指定了请求的页码为 1 和每页的大小为 1000，用于控制分页查询。*/
/*axios.get 方法返回一个 Promise 对象，该对象在异步操作完成后会被解析为一个包含响应数据的对象。根据 axios 库的约定，该响应对象具有以下结构：
* data：响应的数据内容。
status：响应的 HTTP 状态码。
statusText：响应的状态文本。
headers：响应的头部信息。
config：请求的配置信息。
request：发出的请求实例。*/
const init = async () => {
  const { data } = await getAddressList()
  /*如果返回的数据中没有 data 属性，表示获取数据失败，将 state.list 设置为空数组 []，然后函数返回。*/
  if (!data) {
    state.list = []
    return
  }
  /*这里可以在console中看到data的格式*/
  console.log(data)
  /*这里使用map函数，对data中的每一个item执行相同的操作，将结果值返回给了state.list
  * data中isDefault是一个整型变量，这里通过双重逻辑非运算符 !! 可以将其转换为对应的布尔值。*/
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
/*path: 'address-edit' 指定了目标地址为 'address-edit'，表示要导航到名为 'address-edit' 的路由路径。
query: { type: 'add', from: state.from } 指定了查询参数，其中 type: 'add' 和 from: state.from 是查询参数的键值对。*/
const onAdd = () => {
  router.push({ path: 'address-edit', query: { type: 'add', from: state.from  } })
}
// 前往地址编辑页面
/*path: 'address-edit' 指定了目标地址为 'address-edit'，表示要导航到名为 'address-edit' 的路由路径。
query: { type: 'edit', addressId: item.id, from: state.from  }
type: 'edit' 表示编辑操作，addressId: item.id 表示要编辑的地址项的 ID，from: state.from 表示来源信息。*/
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
