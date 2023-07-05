<template >
  <div class="login background" id="HomePage" @click="changeBackground"><!--一个包含登录和注册内容的<div>容器，类名为"login"。-->
    <s-header :name="state.type == 'login' ? '登录' : '注册'" :back="'/home'"></s-header>
    <!--页面顶部的标题栏，通过<s-header>组件实现，标题根据type的值动态显示为"注册"或"登录"，如果type的值是login则返回注册
    返回按钮指向"/home"路径。-->
    <img class="logo" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/cart.png" alt="">
<!-- 应用Logo，通过<img>元素插入图片。-->
    <div v-if="state.type == 'login'" class="login-body login">
<!-- 通过v-if和v-else指令根据state.type的值切换登录和注册内容的显示。-->
<!-- 这个是登陆界面-->
      <!-- 在使用<van-form>组件时，通过添加@submit修饰符来监听表单提交事件。在表单提交后就执行onSubmit这个方法-->
        <van-cell-group inset >
          <van-form @submit="onSubmit">
            <!-- center用于使得文本内容在 <van-field> 组件中水平居中显示。      -->
<!-- icon用于显示图标           -->
            <!-- vmodel将表单元素的值与 Vue 实例中state的username进行绑定，实现数据的双向同步。       -->
            <!-- 该表单字段所在的表单被提交时，后端处理程序可以通过使用"name"作为键来获取该字段的值。       -->
            <!-- label用于设置在表单字段前显示的字段，用于提示用户这里需要输入用户名       -->
<!-- labelwidth用于设置label的宽度           -->
            <!-- placeholder是占位符文本       -->
            <!-- :rules规定用户名字段是必填的，如果用户没有填写用户名，将显示错误消息 '请填写用户名'。       -->
          <van-field
              center
              left-icon="smile-o"
              right-icon="warning-o"
              v-model="state.username"
              name="username"
              label="用户名"
              label-width='50'
              placeholder="用户名"
              :rules="[{ required: true, message: '请填写用户名' }]"
          />
<!--      center 属性将标签和输入框内容居中对齐。-->
<!--            v-model 指令用于实现数据的双向绑定，将输入框中的值绑定到 Vue 实例中的 state.password 属性上。
            type="password" 设置输入框的类型为密码，以隐藏用户输入的敏感信息。
            name 属性指定了字段的名称，在表单提交时会作为参数名发送给服务器。
            @click 监听点击事件，当点击输入框时会触发名为 "changeBackground_S" 的方法。-->
          <van-field
              label-width='50'
              left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E5%AF%86%E7%A0%81.png"
              center
              id='password'
              v-model="state.password"
              type="password"
              name="password"
              label="密码"
              placeholder="密码"
              @click="changeBackground_S"
              :rules="[{ required: true, message: '请填写密码' }]">
<!--            <template #button> 指定了一个插槽的名称为 "button"，用于自定义按钮的内容。
              <span class="solts" @click="switchPasswordType"> 定义了一个 <span> 元素，点击该元素会触发名为 "switchPasswordType" 的方法。
                <van-icon name="eye" v-if="state.see" /> 使用 Vant UI 提供的图标组件 <van-icon>，根据 state.see 的值显示不同的图标，
                  如果 state.see 为真则显示 "eye" 图标，否则显示 "closed-eye" 图标。-->
            <template #button >
              <span class="solts" @click="switchPasswordType">
                <van-icon name="eye" v-if="state.see" />
                <van-icon name="closed-eye" v-else />
              </span>
            </template>
          </van-field>
<!--            输入框中的内容与state.verify相绑定-->
          <van-field
              label-width='50'
              left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E9%AA%8C%E8%AF%81%E7%A0%81.png"
              center
              label="验证码"
              placeholder="验证码"
              v-model="state.verify"
          >
<!--     包含一个vue-img-verify组件，并通过ref属性设置了一个引用名称verifyRef,稍后可以通过这个引用名称来访问这个组件的属性和方法。-->
            <template #button>
              <vue-img-verify ref="verifyRef"/>
            </template>

          </van-field>
          <div style="margin: 8px;">
            <div class="link-register" @click="toggle('register')">还没有账号？立即注册</div>
            <van-button round block
                        icon="https://fastly.jsdelivr.net/npm/@vant/assets/user-active.png"
                        color="linear-gradient(to right, #1baeae, #ff6f00)"
                        native-type="submit">登录</van-button>
          </div>
          </van-form>
        </van-cell-group>




    </div>
    <div v-else class="login-body register">
      <van-cell-group inset size="large">
      <van-form @submit="onSubmit">
        <van-field
            left-icon="smile-o"
            right-icon="warning-o"
            label-width='50'
            center
          v-model="state.username1"
          name="username1"
          label="用户名"
          placeholder="用户名"
          :rules="[{ required: true, message: '请填写用户名' }]"
        />
        <van-field
            left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E5%AF%86%E7%A0%81.png"
            label-width='50'
            center
          v-model="state.password1"
          type="password"
          name="password1"
          id="password1"
          label="密码"
          placeholder="密码"
            @click="changeBackground_S"
          :rules="[{ required: true, message: '请填写密码' }]">
        <template #button >
              <span class="solts" @click="switchPasswordType1">
                <van-icon name="eye" v-if="state.see" />
                <van-icon name="closed-eye" v-else />
              </span>
        </template>
          </van-field>
        <van-field
            left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E9%AA%8C%E8%AF%81%E7%A0%81.png"
            label-width='50'
          center
          clearable
          label="验证码"
          placeholder="验证码"
          v-model="state.verify"
        >
          <template #button>
            <vue-img-verify ref="verifyRef" />
          </template>
        </van-field>
        <div style="margin: 8px;">
          <div class="link-login" @click="toggle('login')">已有账号，直接登录</div>
          <van-button round block
                      icon="https://fastly.jsdelivr.net/npm/@vant/assets/user-active.png"
                      color="linear-gradient(to right, #1baeae, #ff6f00)" native-type="submit">注册</van-button>
        </div>
      </van-form>
        </van-cell-group>

    </div>
    <div> </div>
  </div>
</template>



<script setup>
import { reactive, ref } from 'vue'
import sHeader from '@/components/SimpleHeader.vue'
import vueImgVerify from '@/components/VueImageVerify.vue'
import { login, register } from '@/service/user'
import { setLocal } from '@/common/js/utils'
import md5 from 'js-md5'
import { showSuccessToast, showFailToast } from 'vant'
/*通过Vue的Composition API创建一个响应式引用，初始值为null。这个引用可以用来访问vue-img-verify组件。
* ref函数接收一个参数，即初始值，并返回一个包含两个属性的对象：.value和.valueOf()。*/
const verifyRef = ref(null)
const state = reactive({
  username: '',
  password: '',
  username1: '',
  password1: '',
  type: 'login',
  imgCode: '',
  verify: '',
  see:0,
})

const switchPasswordType =() => {
  state.see=!state.see
  if (state.see){
    document.getElementById('password').type='text'
  }
  else {
    document.getElementById('password').type='password'
  }
}
const switchPasswordType1 =() => {
  state.see=!state.see
  if (state.see){
    document.getElementById('password1').type='text'
  }
  else {
    document.getElementById('password1').type='password'
  }
}

/*执行toggle之后，state.type的值变为v，state.verify的值变为空*/
const toggle = (v) => {
  state.type = v
  state.verify = ''
}

// 提交登录或注册表单
/*定义了一个名为onSubmit的异步函数，这个函数接受一个参数values,用来处理表单提交。这里就是对应的van-form的表单中的数据*/
/*state.imgCode = verifyRef.value.state.imgCode || '' 这行代码从vue-img-verify组件中获取imgCode
，图像验证码的一部分，并将其存储在state.imgCode中。如果imgCode不存在或者是假值，则将空字符串存储在state.imgCode中。*/
/*接下来的代码块检查state.verify和state.imgCode是否相等，不区分大小写。如果不相等，调用showFailToast('验证码有误')来显示一个失败的提示信息，然后退出函数。*/
/*如果验证码验证成功，该函数将检查state.type的值。如果state.type等于'login'，则执行登录逻辑：
a. 使用await关键字等待login函数的结果，该函数以包含loginName和加密的passwordMd5的对象作为参数，是一个发起HTTP请求的函数，用来验证用户名和密码。
b. 使用setLocal函数将服务器返回的数据存储在本地。
c. 重定向用户到主页，并刷新页面。这是为了确保在其他地方的axios.js文件中的token被重置。使用window.location.href = '/'，它会将当前页面的URL重定向到网站的根路径。
如果state.type不等于'login'，则执行注册逻辑：
a. 使用await关键字等待register函数的结果，该函数以包含loginName和password的对象作为参数,这是一个发起HTTP请求的函数，用来注册新用户。
b. 显示一个成功的提示信息，通过调用showSuccessToast('注册成功')。
c. 将state.type设置为'login'，并清空state.verify。
*/
const onSubmit = async (values) => {
  state.imgCode = verifyRef.value.state.imgCode || ''
  if (state.verify.toLowerCase() != state.imgCode.toLowerCase()) {
    showFailToast('验证码有误')
    return
  }

  if (state.type == 'login') {
    /*这里使用的是解构赋值语法，login返回的是一个对象，这里从其中提取data属性*/
    const { data } = await login({
      "loginName": values.username,
      "passwordMd5": md5(values.password)
    })
    setLocal('token', data)
    // 需要刷新页面，否则 axios.js 文件里的 token 不会被重置
    window.location.href = '/'
  } else {
    await register({
      "loginName": values.username1,
      "password": values.password1
    })
    showSuccessToast('注册成功')
    state.type = 'login'
    state.verify = ''
  }
}
</script>


<script>
export default {
  data() {
    return {
      backgroundImage: 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/result.png',
    };
  },
  methods: {
    changeBackground() {
      // 更新背景图片的 URL
      if (this.backgroundImage == 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/result1.png') {
        this.backgroundImage = 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/result.png'
        document.body.style.backgroundImage = `url(${this.backgroundImage})`;
        /*背景图片将不会在水平或垂直方向上重复显示。*/
        document.body.style.backgroundRepeat = 'no-repeat';
        /*当设置为'cover'时，背景图片会被缩放并且保持纵横比，以覆盖整个元素的背景区域。如果图片的宽高比与元素的宽高比不一致，图片可能会被裁剪。*/
        document.body.style.backgroundSize = 'cover';
      }
    },
      changeBackground_S(){
        event.stopPropagation();
        if (this.backgroundImage=='https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/result.png'){
          this.backgroundImage = 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/result1.png'
          document.body.style.backgroundImage = `url(${this.backgroundImage})`;
          document.body.style.backgroundRepeat = 'no-repeat';
          document.body.style.backgroundSize = 'cover';
        }

      }
      // 应用新的背景图片到整个页面

    },
  /*生命周期钩子函数，在组件挂载时被调用。在这个例子中，它用于在组件挂载时设置初始的背景图片样式。*/
  mounted() {
    document.body.style.backgroundImage = `url(${this.backgroundImage})`;
    document.body.style.backgroundRepeat = 'no-repeat';
    document.body.style.backgroundSize = 'cover';
  },
};
</script>

<style lang="less">





  .login {

    .logo {
      width: 120px;
      height: 120px;
      display: block;
      margin: 80px auto 20px;
    }

    .login-body {
      padding: 0 20px;
    }
    .login {
      .link-register {
        font-size: 14px;
        margin-bottom: 20px;
        color: #1989fa;
        display: inline-block;
      }
    }
    .register {
      .link-login {
        font-size: 14px;
        margin-bottom: 20px;
        color: #1989fa;
        display: inline-block;
      }
    }
    .verify-bar-area {
      margin-top: 24px;
      .verify-left-bar {
        border-color: #1baeae;
      }
      .verify-move-block {
        background-color: #1baeae;
        color: #fff;
      }
    }
    .verify {
      >div {
        width: 100%;
      }
      display: flex;
      justify-content: center;
      .cerify-code-panel {
        margin-top: 16px;
      }
      .verify-code {
        width: 40%!important;
        float: left!important;
      }
      .verify-code-area {
        float: left!important;
        width: 54%!important;
        margin-left: 14px!important;
        .varify-input-code {
          width: 90px;
          height: 38px!important;
          border: 1px solid #e9e9e9;
          padding-left: 10px;
          font-size: 16px;
        }
        .verify-change-area {
          line-height: 44px;
        }
      }
    }
  }
</style>
