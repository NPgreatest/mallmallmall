<template>
  <div class="categray">
    <div>
      <header class="category-header wrap van-hairline--bottom">
<!--        创建一个 icon，并设置其类名为 "nbicon" 和 "nbfanhui"。它具有一个 click 事件侦听器，当点击时，会调用 goHome 方法。-->
        <i class="nbicon nbfanhui" @click="goHome"></i>
        <div class="header-search">
          <i class="nbicon nbSearch"></i>
<!--   创建一个 Vue Router 链接，设置其 tag 为 "span"，类名为 "search-title" 并导航到 "./product-list?from=category"。链接文本为 “全场50元起步”。-->
          <router-link tag="span" class="search-title" to="./product-list?from=category">中华有为，就用华为！</router-link>
        </div>
        <i class="iconfont icon-More"></i>
      </header>
<!--      插入一个自定义的 <nav-bar> 组件-->
      <nav-bar></nav-bar>
      <div class="search-wrap" ref="searchWrap">
<!--        插入一个自定义的 <list-scroll> 组件,用于下拉的实现-->
        <list-scroll :scroll-data="state.categoryData" class="nav-side-wrapper">
<!--          <ul class="nav-side"> - 创建左侧的无序列表-->
          <ul class="nav-side">
<!--            使用了 Vue 的 v-for 指令来循环遍历 state.categoryData 数组。对于数组中的每个元素，它创建一个列表项。-->
<!--            :key="item.categoryId" - 是一个绑定的 key 属性，通常用于提高 Vue 列表渲染的性能。这里，它被设置为当前遍历的项的 categoryId 属性。-->
<!--            v-text="item.categoryName" - 是一个指令，它将列表项的文本内容设置为 item 对象的 categoryName 属性。这可以显示分类的名称。-->
<!--            :class="{'active' : state.currentIndex == item.categoryId}" - 是一个绑定的 class 属性。如果当前 state.currentIndex 等于
            item.categoryId，则为此列表项添加 'active' 类。用于高亮展示-->
<!--            @click="selectMenu(item.categoryId)" - 是一个点击事件监听器。当用户点击列表项时，它将调用 selectMenu 方法，
并传递 item.categoryId 作为参数。用于切换高亮展示项目-->
            <li
                v-for="item in state.categoryData"
                :key="item.categoryId"
                v-text="item.categoryName"
                :class="{'active' : state.currentIndex == item.categoryId}"
                @click="selectMenu(item.categoryId)"
            ></li>
          </ul>
        </list-scroll>
<!--<div class="search-content"> - 创建一个 div 容器，并设置其类名为 search-content。
<list-scroll :scroll-data="state.categoryData"> - 使用自定义组件 list-scroll。
它有一个绑定的属性 scroll-data，其值设置为 state.categoryData。
<div class="swiper-container"> - 创建一个 div 容器用于包含 Swiper 轮播。
<div class="swiper-wrapper"> - 内部容器，用于包裹轮播项。
<template v-for="(category, index) in state.categoryData"> - 使用 Vue 的 v-for 指令遍历 state.categoryData 数组。
对于数组中的每个元素，它创建一个模板。category 变量包含当前分类数据，而 index 包含当前索引。
<div class="swiper-slide" v-if="state.currentIndex == category.categoryId" :key="index"> - 这是轮播的单个滑块。
只有当 state.currentIndex 等于 category.categoryId 时，此滑块才会显示。
<div class="category-list" v-for="(products, index) in category.secondLevelCategoryVOS" :key="index">
一个嵌套的 v-for 循环，用于遍历每个分类中的二级分类数据。
<p class="catogory-title">{{products.categoryName}}</p> - 显示二级分类的名称。
<div class="product-item" v-for="(product, index) in products.thirdLevelCategoryVOS" :key="index" @click="selectProduct(product)">
 - 再次嵌套的 v-for 循环，这次用于遍历三级分类数据，也就是产品。
 <p v-text="product.categoryName" class="product-title"></p> - 显示产品的名称。
-->
        <div class="search-content">
          <list-scroll :scroll-data="state.categoryData" >
            <div class="swiper-container">
              <div class="swiper-wrapper">
                <template v-for="(category, index) in state.categoryData">
                  <div class="swiper-slide" v-if="state.currentIndex == category.categoryId" :key="index">
                    <div class="category-list" v-for="(products, index) in category.secondLevelCategoryVOS" :key="index">
                      <p class="catogory-title">{{products.categoryName}}</p>
                      <div class="product-item" v-for="(product, index) in products.thirdLevelCategoryVOS" :key="index" @click="selectProduct(product)">
                        <img src="//s.weituibao.com/1583591077131/%E5%88%86%E7%B1%BB.png" class="product-img"/>
                        <p v-text="product.categoryName" class="product-title"></p>
                      </div>
                    </div>
                  </div>
                </template>
              </div>
            </div>
          </list-scroll>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import navBar from '@/components/NavBar.vue'
import listScroll from '@/components/ListScroll.vue'
import { getCategory } from "@/service/good"
import { showLoadingToast, closeToast } from 'vant'
const router = useRouter()
// composition API 获取 refs 的形式
const searchWrap = ref(null)
const state = reactive({
  categoryData: [],
  currentIndex: 15
})
/*展示当前浏览器窗口的可视高度
* searchWrap.value
*
* */
onMounted(async () => {
/*声明一个变量$screenHeight，并将其设置为document.documentElement.clientHeight，即当前浏览器窗口的可视高度。*/
  let $screenHeight = document.documentElement.clientHeight
  console.log('searchWrap.value', searchWrap.value)
  /*将searchWrap.value.style.height设置为$screenHeight - 100 + 'px'，即浏览器窗口可视高度减去100像素，并以像素为单位设置给searchWrap元素的高度属性。*/
  searchWrap.value.style.height = $screenHeight - 100 + 'px'
  showLoadingToast('加载中...')
  /*getCategory()中解构获得data属性*/
  const { data } = await getCategory()
  closeToast()
  /*将data赋值给state.categoryData*/
  state.categoryData = data
})

const goHome = () => {
  router.push({ path: 'home' })
}
/*当前的选中项*/
const selectMenu = (index) => {
  state.currentIndex = index
}
/*使用console.log打印出item.categoryId的值。item是一个对象，它包含一个名为categoryId的属性。
这行代码的目的是在控制台输出item.categoryId的值，以便进行调试或查看输出结果。
使用router.push方法进行页面导航。它接受一个对象作为参数，该对象包含导航的相关信息。在这里，它将导航到'/product-list'路径，
并通过query属性传递了一个参数categoryId，值为item.categoryId，表示在导航到'/product-list'页面时，将附带一个查询参数categoryId，
其值为item.categoryId。*/
const selectProduct = (item) => {
  console.log('item', item.categoryId)
  router.push({ path: '/product-list', query: { categoryId: item.categoryId } })
}
</script>
<style lang="less" scoped>
  @import '../common/style/mixin';
  .categray {
    .category-header {
      background: #fff;
      position: fixed;
      left: 0;
      top: 0;
      .fj();
      .wh(100%, 50px);
      line-height: 50px;
      padding: 0 15px;
      box-sizing: border-box;
      font-size: 15px;
      color: #656771;
      z-index: 10000;
      &.active {
        background: @primary;
      }
      .icon-left {
        font-size: 25px;
        font-weight: bold;
      }
      .header-search {
        display: flex;
        width: 80%;
        height: 20px;
        line-height: 20px;
        margin: 10px 0;
        padding: 5px 0;
        color: #232326;
        background: #F7F7F7;
        border-radius: 20px;
        .nbSearch {
          padding: 0 10px 0 20px;
          font-size: 17px;
        }
        .search-title {
          font-size: 12px;
          color: #666;
          line-height: 21px;
        }
      }
      .icon-More {
        font-size: 20px;
      }
    }
  }
  .search-wrap {
    .fj();
    width: 100%;
    margin-top: 50px;
    background: #F8F8F8;
    .nav-side-wrapper {
      width: 28%;
      height: 100%;
      overflow: hidden;
      .nav-side {
        width: 100%;
        .boxSizing();
        background: #F8F8F8;
        li {
          width: 100%;
          height: 56px;
          text-align: center;
          line-height: 56px;
          font-size: 14px;
          &.active {
            color: @primary;
            background: #fff;
          }
        }
      }
    }
    .search-content {
      width: 72%;
      height: 100%;
      padding: 0 10px;
      background: #fff;
      overflow-y: scroll;
      touch-action: pan-y;
      * {
          touch-action: pan-y;
        }
      .boxSizing();
      .swiper-container {
        width: 100%;
        .swiper-slide {
          width: 100%;
          .category-main-img {
            width: 100%;
          }
          .category-list {
            display: flex;
            flex-wrap: wrap;
            flex-shrink: 0;
            width: 100%;
            .catogory-title {
              width: 100%;
              font-size: 17px;
              font-weight: 500;
              padding: 20px 0;
            }
            .product-item {
              width: 33.3333%;
              margin-bottom: 10px;
              text-align: center;
              font-size: 15px;
              .product-img {
                .wh(30px, 30px);
              }
            }
          }
        }
      }
    }
  }
  .fade-out-enter-active, .fade-out-leave-active {
    // transition: opacity 0.5s;
  }

  .fade-out-enter, .fade-out-leave-to {
    // opacity: 0;
  }
</style>