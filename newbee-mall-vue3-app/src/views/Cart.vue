<template>
  <div class="cart-box"><div class="cart-body">
<!--    使用了 <van-checkbox-group> 组件来创建一个复选框组，用于选择购物车中的商品。
    v-model 指令绑定了 state.result，表示选中的商品项的结果会保存在 state.result 中。
    <div class="good-item">，用于显示每个商品项的内容。这里使用了 <van-checkbox> 组件来创建一个复选框，
    :name="item.cartItemId" 属性设置了复选框的名称为当前商品项的 cartItemId。
    :src="$filters.prefix(item.goodsCoverImg)" 绑定了商品图片的 src 属性，并通过过滤器 $filters.prefix 处理了图片的路径。-->
    <van-checkbox-group @change="groupChange" v-model="state.result" ref="checkboxGroup">
<!--      使用了 <van-swipe-cell> 组件来创建可滑动的单元格，用于显示每个商品项。
滑动之后会展示删除按钮-->
      <van-swipe-cell :right-width="50" v-for="(item, index) in state.list" :key="index">
        <div class="good-item">
          <van-checkbox :name="item.cartItemId" />
          <div class="good-img"><img :src="$filters.prefix(item.goodsCoverImg)" alt=""></div>
          <div class="good-desc">
            <div class="good-title">
<!--              商品名称和商品数-->
              <span>{{ item.goodsName }}</span>
              <span>x{{ item.goodsCount }}</span>
            </div>
            <div class="good-btn">
<!--              商品价格-->
              <div class="price">¥{{ item.sellingPrice }}</div>
<!--              进行加减控制商品数，最小为1，最大为5-->
              <van-stepper
                  integer
                  :min="1"
                  :max="5"
                  :model-value="item.goodsCount"
                  :name="item.cartItemId"
                  async-change
                  @change="onChange"
              />
            </div>
          </div>
        </div>
        <template #right>
          <van-button
              square
              icon="delete"
              type="danger"
              class="delete-button"
              @click="deleteGood(item.cartItemId)"
          />
        </template>
      </van-swipe-cell>
    </van-checkbox-group>
  </div>
<!--    最底下的提交框-->
    <van-submit-bar
        v-if="state.list.length > 0"
        class="submit-all van-hairline--top"
        :price="total * 100"
        button-text="结算"
        button-type="primary"
        @submit="onSubmit"
    >
<!--      全部选择的复选框-->
<!--      @click="allCheck" 是一个点击事件监听器，当全选复选框被点击时，会调用 allCheck 方法。
v-model:checked="state.checkAll" 表示将 state.checkAll 的值与全选复选框的选中状态进行双向绑定，从而控制全选复选框的选中状态。-->
      <van-checkbox @click="allCheck" v-model:checked="state.checkAll">全选</van-checkbox>
    </van-submit-bar>
<!--    如果购物车中不存在商品则显示，-->
    <div class="empty" v-if="!state.list.length">
      <img class="empty-cart" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/empty-cart.png" alt="空购物车">
      <div class="title">购物车空空如也</div>
<!--      进行跳转的按钮-->
      <van-button round color="#1baeae" type="primary" @click="goTo" block>前往选购</van-button>
    </div>
    <nav-bar></nav-bar>
  </div>
</template>

<s-header :name="'购物车'" :noback="true"></s-header>

<script setup>
import { reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '@/stores/cart'
import { showToast, showLoadingToast, closeToast, showFailToast } from 'vant'
import navBar from '@/components/NavBar.vue'
import sHeader from '@/components/SimpleHeader.vue'
import { getCart, deleteCartItem, modifyCart } from '@/service/cart'
/*router 是 Vue Router 路由实例的引用。*/
const router = useRouter()
const cart = useCartStore()
/*通过使用 reactive 函数，将这些属性转换为响应式的，意味着当这些属性的值发生变化时，相关的依赖会自动更新。*/
const state = reactive({
  checked: false,
  list: [],
  all: false,
  result: [],
  checkAll: true
})
/*在组件挂载到 DOM 后执行init*/
onMounted(() => {
  init()
})

const init = async () => {
  showLoadingToast({ message: '加载中...', forbidClick: true });
  /*执行的是axios.get函数请求的 URL 是 '/shop-cart'，购物车数据的接口路径。参数为pageNumber: 1
  * 使用解构赋值将响应的 data 属性解构出来，表示获取到的购物车数据。 */

  const { data } = await getCart({ pageNumber: 1 })

  /*将获取到的购物车数据赋值给 state.list，以更新组件的状态，可能用于在页面中展示购物车列表。
  * 使用 data.map(item => item.cartItemId) 将购物车数据中每个元素的 cartItemId 属性提取出来，形成一个新的数组。
  * 在加载完成后默认全选*/
  state.list = data
  state.result = data.map(item => item.cartItemId)
  closeToast()
}

const total = computed(() => {
  let sum = 0
  /*通过对 state.list 数组进行筛选，只保留 state.result 中选中的购物车项，将筛选后的结果赋值给 _list 变量。*/
  let _list = state.list.filter(item => state.result.includes(item.cartItemId))
  /*使用 forEach 方法遍历 _list 数组中的每个购物车项。对于每个购物车项，将其 goodsCount（商品数量）与 sellingPrice（销售价格）相乘
  ，得到该商品项的金额，并累加到 sum 变量中。*/
  _list.forEach(item => {
    sum += item.goodsCount * item.sellingPrice
  })
  return sum
})


/*跳转到home主页*/
const goTo = () => {
  router.push({ path: '/home' })
}

const onChange = async (value, detail) => {
  if (value > 5) {
    showFailToast('超出单个商品的最大购买数量')
    return
  }
  if (value < 1) {
    showFailToast('商品不得小于0')
    return
  }

  /*这里通过查找 state.list 数组中的购物车项，判断是否已存在与当前操作的购物车项（通过 detail.name 来标识）具有相同数量的商品。
  如果已存在相同数量的商品，则直接返回，不再进行修改操作。这个步骤是为了防止重复触发修改操作，确保数据的正确性。*/
  if (state.list.find(item => item.cartItemId == detail.name)?.goodsCount == value) return
  /*如果需要进行修改操作，调用 showLoadingToast 方法显示一个修改中的提示*/
  showLoadingToast({ message: '修改中...', forbidClick: true });
  const params = {
    cartItemId: detail.name,
    goodsCount: value
  }
  await modifyCart(params)
  /*发送一个 HTTP PUT 请求来修改购物车项。请求的 URL 是 '/shop-cart'，对应修改购物车项的接口路径。*/

  state.list.forEach(item => {
    if (item.cartItemId == detail.name) {
      item.goodsCount = value
    }
  })
  /*关闭”修改中的提示“*/
  closeToast()
}

const onSubmit = async () => {
  /*如果并没有商品，那么显示请选择商品进行结算*/
  if (state.result.length == 0) {
    showFailToast('请选择商品进行结算')
    return
  }
/*  如果有商品被选中进行结算，代码会创建一个 params 变量，将 state.result 数组转换为 JSON 字符串，并赋值给 params。
* 最后，代码使用 router.push 方法进行页面跳转。它将导航到路径为 '/create-order' 的页面，并传递一个名为 'cartItemIds' 的查询参数，
* 值为之前生成的 params 字符串。*/
  const params = JSON.stringify(state.result)
  router.push({ path: '/create-order', query: { cartItemIds: params } })
}
/*发送delete请求来修改购物车*/
const deleteGood = async (id) => {
  await deleteCartItem(id)
  cart.updateCart()
  location.reload();
  init()
}

const groupChange = (result) => {
  if (result.length == state.list.length) {
    state.checkAll = true
  } else {
    state.checkAll = false
  }
  state.result = result
}

const allCheck = () => {
  /*如果没有全选，那么就全选*/
  if (!state.checkAll) {
    state.result = state.list.map(item => item.cartItemId)
  }
/*  如果全选了，那么就全部取消*/
  else {
    state.result = []
  }
}
</script>

<style lang="less">
  @import '../common/style/mixin';
  .cart-box {
    .cart-header {
      position: fixed;
      top: 0;
      left: 0;
      z-index: 10000;
      .fj();
      .wh(100%, 44px);
      line-height: 44px;
      padding: 0 10px;
      .boxSizing();
      color: #252525;
      background: #fff;
      border-bottom: 1px solid #dcdcdc;
      .cart-name {
        font-size: 14px;
      }
    }
    .cart-body {
      margin: 16px 0 100px 0;
      padding-left: 10px;
      .good-item {
        display: flex;
        .good-img {
          img {
            .wh(100px, 100px)
          }
        }
        .good-desc {
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          flex: 1;
          padding: 20px;
          .good-title {
            display: flex;
            justify-content: space-between;
          }
          .good-btn {
            display: flex;
            justify-content: space-between;
            .price {
              font-size: 16px;
              color: red;
              line-height: 28px;
            }
            .van-icon-delete {
              font-size: 20px;
              margin-top: 4px;
            }
          }
        }
      }
      .delete-button {
        width: 50px;
        height: 100%;
      }
    }
    .empty {
      width: 50%;
      margin: 0 auto;
      text-align: center;
      margin-top: 200px;
      .empty-cart {
        width: 150px;
        margin-bottom: 20px;
      }
      .van-icon-smile-o {
        font-size: 50px;
      }
      .title {
        font-size: 16px;
        margin-bottom: 20px;
      }
    }
    .submit-all {
      margin-bottom: 64px;
      .van-checkbox {
        margin-left: 10px
      }
      .van-submit-bar__text {
        margin-right: 10px
      }
      .van-submit-bar__button {
        background: @primary;
      }
    }
    .van-checkbox__icon--checked .van-icon {
      background-color: @primary;
      border-color: @primary;
    }
  }
</style>
