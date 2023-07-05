

<template>
  <div class="order-detail-box">
    <s-header :name="'订单详情'" ></s-header>
    <div class="order-status">
      <div class="status-item">
        <label>订单状态：</label>
        <span>{{ state.detail.orderStatusString }}</span>
      </div>
      <div class="status-item">
        <label>订单编号：</label>
        <span>{{ state.detail.orderNo }}</span>
      </div>
      <div class="status-item">
        <label>下单时间：</label>
        <span>{{ state.detail.createTime }}</span>
      </div>
<!--      根据订单目前的状态来决定显示的按钮类型-->
<!--      如果state.detail.orderStatus == 0就显示去支付，点击后弹出支付窗口-->
      <van-button v-if="state.detail.orderStatus == 3" style="margin-bottom: 10px" color="#1baeae" block @click="handleConfirmOrder(state.detail.orderNo)">确认收货</van-button>
      <van-button v-if="state.detail.orderStatus == 0" style="margin-bottom: 10px" color="#1baeae" block @click="showPayFn">去支付</van-button>
      <van-button v-if="!(state.detail.orderStatus < 0 || state.detail.orderStatus == 4)" block @click="handleCancelOrder(state.detail.orderNo)">取消订单</van-button>
    </div>
    <div class="order-price">
      <div class="price-item">
        <label>商品金额：</label>
        <span>¥ {{ state.detail.totalPrice }}</span>
      </div>
      <div class="price-item">
        <label>配送方式：</label>
        <span>普通快递</span>
      </div>
    </div>
    <van-card
      v-for="item in state.detail.newBeeMallOrderItemVOS"
      :key="item.goodsId"
      style="background: #fff"
      :num="item.goodsCount"
      :price="item.sellingPrice"
      desc="全场包邮"
      :title="item.goodsName"
      :thumb="$filters.prefix(item.goodsCoverImg)"
    />
    <van-popup
      v-model:show="state.showPay"
      position="bottom"
      :style="{ height: '24%' }"
    >
      <div :style="{ width: '90%', margin: '0 auto', padding: '20px 0' }">
        <van-button :style="{ marginBottom: '10px' }" color="#1989fa" block @click="handlePayOrder(state.detail.orderNo, 1)">支付宝支付</van-button>
        <van-button color="#4fc08d" block @click="handlePayOrder(state.detail.orderNo, 2)">微信支付</van-button>
      </div>
    </van-popup>
  </div>
</template>

<script setup>
import { reactive, toRefs, onMounted } from 'vue'
import sHeader from '@/components/SimpleHeader.vue'
import { getOrderDetail, cancelOrder, confirmOrder, payOrder } from '@/service/order'
import { showConfirmDialog, showLoadingToast, closeToast, showSuccessToast, closeDialog } from 'vant'
import { useRoute } from 'vue-router'
const route = useRoute()
const state = reactive({
  detail: {},
  showPay: false
})

onMounted(() => {
  init()
})

const init = async () => {
  showLoadingToast({
    message: '加载中...',
    /*当加载提示显示时，用户不能点击其他元素。*/
    forbidClick: true
  });
/*  使用解构赋值从 route.query 对象中提取 id 属性。*/
  const { id } = route.query
  /*根据id从服务器获取订单详细信息*/
  const { data } = await getOrderDetail(id)
  state.detail = data
  closeToast()
}

const handleCancelOrder = (id) => {
  showConfirmDialog({
    title: '确认取消订单？',
  }).then(() => {
    cancelOrder(id).then(res => {
      if (res.resultCode == 200) {
        showSuccessToast('删除成功')
        init()
      }
    })
  }).catch(() => {
    // on cancel
  });
}

const handleConfirmOrder = (id) => {
  showConfirmDialog({
    title: '是否确认订单？',
  }).then(() => {
    confirmOrder(id).then(res => {
      /*表示一个 HTTP 请求已成功完成，检查订单确认是否成功。*/
      if (res.resultCode == 200) {
        showSuccessToast('确认成功')
        init()
      }
    })
    /*在最初的 showConfirmDialog 的 Promise 链上，有一个 .catch 方法。这个 .catch
    用于处理任何在 Promise 链中发生的错误或者如果用户取消对话框。在这个例子中，.catch 的回调函数是空的，这意味着如果用户取消或发生错误，不执行任何操作。*/
  }).catch(() => {
    // on cancel
  });
}

const showPayFn = () => {
  state.showPay = true
}

const handlePayOrder = async (id, type) => {
  await payOrder({ orderNo: id, payType: type })
  state.showPay = false
  init()
}


</script>

<style lang="less" scoped>
  .order-detail-box {
    background: #f7f7f7;
    .order-status {
      background: #fff;
      padding: 20px;
      font-size: 15px;
      .status-item {
        margin-bottom: 10px;
        label {
          color: #999;
        }
        span {

        }
      }
    }
    .order-price {
      background: #fff;
      margin: 20px 0;
      padding: 20px;
      font-size: 15px;
      .price-item {
        margin-bottom: 10px;
        label {
          color: #999;
        }
        span {

        }
      }
    }
    .van-card {
      margin-top: 0;
    }
    .van-card__content {
      display: flex;
      flex-direction: column;
      justify-content: center;
    }
  }
</style>
