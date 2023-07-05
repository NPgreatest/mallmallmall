<template>

    <section class="parallax">
      <img :style="hill1Style" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/hill1.png" id="hill1">
      <img src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/hill2.png" id="hill2">
      <img src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/hill3.png" id="hill3">
      <img :style="hill4Style" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/hill4.png" id="hill4">
      <img :style="hill5Style" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/hill5.png" id="hill5">
      <img src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/tree.png" id="tree">
      <h2 :style="textStyle" id="text">OneForAll Mall | All Might</h2>
      <img :style="leafStyle" src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/leaf.png" id="leaf">
      <img src="https://new-bee-mall.oss-cn-shanghai.aliyuncs.com/images/plant.png" id="plant">
    </section>
    <section class="sec">
      <h2>OneForAll Mall | All Might</h2>
      <p>orem ipsum dolor sit amet consectetur adipisicing elit. In explicabo eius beatae, rerum velit tenetur sint
        aliquid sapiente nesciunt recusandae ipsum dolore ducimus aut ab neque minus libero soluta? Quis, asperiores
        non a provident quasi repellat. Ab voluptatum voluptas, accusamus aliquid, provident ullam autem dolorem,
        laudantium minima veniam veritatis nam obcaecati facilis culpa fuga suscipit eius. Libero natus excepturi
        cum distinctio commodi deserunt minus repellat voluptas non necessitatibus provident eaque, praesentium
        explicabo cupiditate enim mollitia quia ut. Cupiditate, ipsam ullam nemo harum nulla sequi quas nihil, amet
        itaque, pariatur similique. Beatae facilis consectetur sapiente? Vitae iste ducimus et quae quo hic, vero
        sequi enim a voluptatem numquam, magnam adipisci, facilis veniam tempore cupiditate! Quae dolor quia illum,
        veritatis perspiciatis animi officia magni deleniti aliquam iste accusantium sapiente, corrupti, numquam
        beatae!<br><br>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. In explicabo eius beatae, rerum velit tenetur sint
        aliquid sapiente nesciunt recusandae ipsum dolore ducimus aut ab neque minus libero soluta? Quis, asperiores
        non a provident quasi repellat. Ab voluptatum voluptas, accusamus aliquid, provident ullam autem dolorem,
        laudantium minima veniam veritatis nam obcaecati facilis culpa fuga suscipit eius. Libero natus excepturi
        cum distinctio commodi deserunt minus repellat voluptas non necessitatibus provident eaque, praesentium
        explicabo cupiditate enim mollitia quia ut. Cupiditate, ipsam ullam nemo harum nulla sequi quas nihil, amet
        itaque, pariatur similique. Beatae facilis consectetur sapiente? Vitae iste ducimus et quae quo hic, vero
        sequi enim a voluptatem numquam, magnam adipisci, facilis veniam tempore cupiditate! Quae dolor quia illum,
        veritatis perspiciatis animi officia magni deleniti aliquam iste accusantium sapiente, corrupti, numquam
        beatae!<br><br>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. In explicabo eius beatae, rerum velit tenetur sint
        aliquid sapiente nesciunt recusandae ipsum dolore ducimus</p>
    </section>

</template>
<script setup>
import DialogAddCategory from "@/components/DialogAddCategory.vue";
const goJuejin = () => {
}
</script>
<script>
export default {
  name: 'ParallaxView',
  data() {
    return {
      scrollY: 0
    }
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll);
  },
  methods: {
    handleScroll() {
      this.scrollY = window.scrollY;
    }
  },
  computed: {
    textStyle() {
      return { marginTop: this.scrollY * 1.5 + 'px' };
    },
    leafStyle() {
      return { top: this.scrollY * -1.5 + 'px', left: this.scrollY * 1.5 + 'px' };
    },
    hill1Style() {
      return { top: this.scrollY * 0.5 + 'px' };
    },
    hill4Style() {
      return { left: this.scrollY * -1.5 + 'px' };
    },
    hill5Style() {
      return { left: this.scrollY * 1.5 + 'px' };
    }
  }
}
</script>


<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Poppins', sans-serif;
}

::selection {
  background: rgba(0, 0, 0, .2);
}

body {
  background: #f9f9f9;
  min-height: 100vh;
  overflow-x: hidden;
}

header {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  padding: 30px 100px;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  z-index: 100;
}

.logo {
  font-size: 2em;
  color: #359381;
  pointer-events: none;
  margin-right: 270px;
}

.navigation a {
  text-decoration: none;
  color: #359381;
  padding: 6px 15px;
  border-radius: 20px;
  margin: 0 10px;
  font-weight: 600;
}

.navigation a:hover,
.navigation a.active {
  background: #359381;
  color: #fff;
}

.parallax {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

#text {
  position: absolute;
  font-size: 5em;
  color: #fff;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, .2);
}

.parallax img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  pointer-events: none;
}

.sec {
  position: relative;
  background: #003329;
  padding: 100px;
}

.sec h2 {
  font-size: 3em;
  color: #fff;
  margin-bottom: 10px;
}

.sec p {
  font-size: 1em;
  color: #fff;
  font-weight: 300;
}
</style>