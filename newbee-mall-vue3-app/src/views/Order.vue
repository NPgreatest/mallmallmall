
<template>
  <div class="order-box">
    <s-header :name="'我的订单'" :back="'/user'"></s-header>
<!--    页面顶部的选项卡-->
<!--    onChangeTab定义了一个名为onChangeTab的箭头函数，接受一个参数对象，其中的name属性表示选中选项卡的名称。-->
    <van-tabs @click-tab="onChangeTab" :color="'#1baeae'" :title-active-color="'#1baeae'" class="order-tab" v-model="state.status">
      <van-tab title="全部" name=''></van-tab>
      <van-tab title="待付款" name="0"></van-tab>
      <van-tab title="待确认" name="1"></van-tab>
      <van-tab title="待发货" name="2"></van-tab>
      <van-tab title="已发货" name="3"></van-tab>
      <van-tab title="交易完成" name="4"></van-tab>
    </van-tabs>
    <div class="content">
<!--      下拉刷新组件，通过v-model绑定到state.refreshing，表示是否正在刷新。-->
<!--      当下拉刷新时，将调用名为onRefresh的方法。-->
      <van-pull-refresh v-model="state.refreshing" @refresh="onRefresh" class="order-list-refresh">
<!--        van-list用于显示订单列表，将state.loading与列表的加载状态进行绑定，用于控制加载状态的显示。
:finished="state.finished"表示列表是否已加载完毕，决定是否显示"没有更多了"的提示。-->
<!--        当列表滚动到底部时，将调用名为onLoad的方法。
@offset="10"设置列表滚动到底部时的偏移量，即距离底部多少像素触发加载。-->
        <van-list
          v-model:loading="state.loading"
          :finished="state.finished"
          finished-text="没有更多了"
          @load="onLoad"
          @offset="10"
        >
          <div v-for="(item, index) in state.list" :key="index" class="order-item-box" @click="goTo(item.orderNo)">
            <div class="order-item-header">
<!--              订单时间和订单状态-->
              <span>订单时间：{{ item.createTime }}</span>
              <span>{{ item.orderStatusString }}</span>
            </div>
<!--            将一个订单中的所有商品列出来-->
            <van-card
              v-for="one in item.newBeeMallOrderItemVOS"
              :key="one.orderId"
              :num="one.goodsCount"
              :price="one.sellingPrice"
              desc="全场包邮"
              :title="one.goodsName"
              :thumb="$filters.prefix(one.goodsCoverImg)"
            />
          </div>
        </van-list>
      </van-pull-refresh>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue';
import sHeader from '@/components/SimpleHeader.vue'
import { getOrderList } from '@/service/order'
import { useRouter } from 'vue-router'

const router = useRouter()
const state = reactive({
  status: '',
  loading: false,
  finished: false,
  refreshing: false,
  list: [],
  page: 1,
  totalPage: 0
})

const loadData = async () => {
  /*将getOrderList函数返回的数据对象中的data属性解构出来，并将其内部的list属性也解构出来。*/
  const { data, data: { list } } = await getOrderList({ pageNumber: state.page, status: state.status })
  /*state.list = state.list.concat(list)将获取到的订单列表数据list与当前的订单列表state.list进行合并，将新的数据追加到已有的数据之后。*/
  state.list = state.list.concat(list)
  /*state.totalPage = data.totalPage将获取到的总页数totalPage赋值给state.totalPage，更新总页数。*/
  state.totalPage = data.totalPage
  /*state.loading = false将加载状态state.loading设置为false，表示数据加载完成。*/
  state.loading = false;
  /*检查当前页数是否大于等于总页数。如果满足条件，则将state.finished设置为true，表示没有更多数据可加载。*/
  if (state.page >= data.totalPage) state.finished = true
}
/*更换所选择的tab*/
const onChangeTab = ({ name }) => {
  // 这里 Tab 最好采用点击事件，@click，如果用 @change 事件，会默认进来执行一次。
  state.status = name
  onRefresh()
}
/*前往对应选中状态订单的页面*/
const goTo = (id) => {
  router.push({ path: '/order-detail', query: { id } })
}



const onLoad = () => {
  /*!state.refreshing：确保不是正在进行下拉刷新操作。
state.page < state.totalPage：确保当前页数小于总页数，以避免加载超出范围的数据*/
  if (!state.refreshing && state.page < state.totalPage) {
    /**/
    console.log(state.page)
    console.log(state.totalPage)
    /*state.page = state.page + 1：将state.page加1，表示加载下一页的数据。*/
    state.page = state.page + 1
  }
  /*如果正在进行下拉刷新操作
  * state.list = []：将state.list清空，即清空订单列表数据。
state.refreshing = false：将state.refreshing设置为false，表示下拉刷新操作完成。*/
  if (state.refreshing) {
    state.list = [];
    state.refreshing = false;
  }
  loadData()
}

const onRefresh = () => {
  state.refreshing = true
  state.finished = false
  state.loading = true
  state.page = 1
  onLoad()
}
</script>

<style lang="less" scoped>
  @import '../common/style/mixin';
  .order-box {
    .order-header {
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
      .order-name {
        font-size: 14px;
      }
    }
    .order-tab {
      position: fixed;
      left: 0;
      z-index: 1000;
      width: 100%;
      border-bottom: 1px solid #e9e9e9;
    }
    .skeleton {
      margin-top: 60px;
    }
    .content {
      height: calc(~"(100vh - 70px)");
      overflow: hidden;
      overflow-y: scroll; 
      margin-top: 34px;
    }
    .order-list-refresh {
      .van-card__content {
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
      .van-pull-refresh__head {
        background: #f9f9f9;
      }
      .order-item-box {
        margin: 20px 10px;
        background-color: #fff;
        .order-item-header {
          padding: 10px 20px 0 20px;
          display: flex;
          justify-content: space-between;
        }
        .van-card {
          background-color: #fff;
          margin-top: 0;
        }
      }
    }
  }
</style>
