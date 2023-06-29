<template >
  <div class="login background" id="HomePage" @click="changeBackground"><!--一个包含登录和注册内容的<div>容器，类名为"login"。-->
    <s-header :name="type == 'login' ? '登录' : '注册'" :back="'/home'"></s-header>
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
            <!-- :rules用户名字段是必填的，如果用户没有填写用户名，将显示错误消息 '请填写用户名'。       -->
          <van-field
              center
              left-icon="smile-o"
              right-icon="warning-o"
              v-model="state.username"
              name="username"
              label="用户名"
              label-width='60'
              placeholder="用户名"
              :rules="[{ required: true, message: '请填写用户名' }]"
          />
          <van-field
              label-width='60'
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
            <template #button >
              <span class="solts" @click="switchPasswordType">
                <van-icon name="eye" v-if="state.see" />
                <van-icon name="closed-eye" v-else />
              </span>
            </template>
          </van-field>
          <van-field
              label-width='60'
              left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E9%AA%8C%E8%AF%81%E7%A0%81.png"
              center
              label="验证码"
              placeholder="验证码"
              v-model="state.verify"
          >
            <template #button>
              <vue-img-verify ref="verifyRef"/>
            </template>
          </van-field>
          <div style="margin: 8px;">
            <div class="link-register" @click="toggle('register')">还没有账号？立即注册</div>
            <van-button round block
                        icon="https://fastly.jsdelivr.net/npm/@vant/assets/user-active.png"
                        color="linear-gradient(to right, #1baeae, #ff6f00)"
                        native-type="submit" class="gradient-button">登录</van-button>
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
            label-width='60'
            center
          v-model="state.username1"
          name="username1"
          label="用户名"
          placeholder="用户名"
          :rules="[{ required: true, message: '请填写用户名' }]"
        />
        <van-field
            left-icon="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E5%AF%86%E7%A0%81.png"
            label-width='60'
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
            label-width='60'
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


const toggle = (v) => {
  state.type = v
  state.verify = ''
}

// 提交登录或注册表单
const onSubmit = async (values) => {
  state.imgCode = verifyRef.value.state.imgCode || ''
  if (state.verify.toLowerCase() != state.imgCode.toLowerCase()) {
    showFailToast('验证码有误')
    return
  }
  if (state.type == 'login') {
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
      backgroundImage: 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/mate30p2.png',
    };
  },
  methods: {
    changeBackground() {
      // 更新背景图片的 URL
      if (this.backgroundImage == 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E5%AF%8C%E5%A3%AB%E5%B1%B1%E8%A1%97.jpeg') {
        this.backgroundImage = 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/mate30p2.png'
        document.body.style.backgroundImage = `url(${this.backgroundImage})`;
        document.body.style.backgroundRepeat = 'no-repeat';
        document.body.style.backgroundSize = 'cover';
      }
    },
      changeBackground_S(){
        event.stopPropagation();
        if (this.backgroundImage=='https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/mate30p2.png'){
          this.backgroundImage = 'https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/%E5%AF%8C%E5%A3%AB%E5%B1%B1%E8%A1%97.jpeg'
          document.body.style.backgroundImage = `url(${this.backgroundImage})`;
          document.body.style.backgroundRepeat = 'no-repeat';
          document.body.style.backgroundSize = 'cover';
        }

      }
      // 应用新的背景图片到整个页面

    },
  // 当组件挂载时，设置初始的背景图片
  mounted() {
    document.body.style.backgroundImage = `url(${this.backgroundImage})`;
    document.body.style.backgroundRepeat = 'no-repeat';
    document.body.style.backgroundSize = 'cover';
  },
};
</script>

<style lang="less">




  .gradient-button {

    color: #FFFFFF;
    /* 其他样式属性 */
  }
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
