/**
 * On slideja joissa on
 *
 * - header ja pikkuheader
 * - fullscreen ja pienennetty
 * - joihin kuva lisätään data attribuutista
 * - ja vaikka kuinka paljon muita!
 *
 * esim.
 * - leijuvia slaideja, animoituja kaikin tavoin
 * - interaktiivisia
 *
 * => dekoraattori
 */
class Slide {
  /**
   * @param {*} el $(<li>)
   */
  constructor(el) {
    this.el = el;
    this.init();
  }
  init() {}
  image() {
    return this.el.find("img");
  }
  h1() {
    return this.el.find("h1");
  }
  h5() {
    return this.el.find("h5");
  }
  showH1() {
    if (this.h1().length < 1) return;
    // console.log("Slide#showH1() 1", this.h1().get(0));
    this.h1().get(0).style.transition = this.h1().get(0).dataset.transition;
    this.h1().addClass("show");
    // data-transition=""opacity:1;scale:1.5px;duration:600ms;easing:easeFastSlow;"
    //this.h1().get(0).style.transition = "opacity 2s, scale 2s";
    // this.h1().css("transition-timing-function", "ease-fast-slow");
    // this.h1().get(0).style.visibility = "visible";
    // this.h1().get(0).style.opacity = "1";
    // this.h1().get(0).style.scale = "4";
    // console.log("Slide#showH1() 2", this.h1().get(0));
  }
  hideH1() {
    if (this.h1().length < 1) return;
    // console.log("Slide#hideH1() 1", this.h1().get(0));
    this.h1().removeClass("show");
    // this.h1().get(0).style.transition = "";
    // this.h1().get(0).style.visibility = "hidden";
    // this.h1().get(0).style.opacity = "0";
    // this.h1().get(0).style.scale = "1";
    // console.log("Slide#hideH1() 2", this.h1().get(0));
  }
  showH5() {
    if (this.h5().length < 1) return;
    this.h5().get(0).style.transition = this.h5().get(0).dataset.transition;
    this.h5().addClass("show");
    // this.h5().css("transition-timing-function", "ease-fast-slow");
    // this.h5().get(0).style.visibility = "visible";
    // this.h5().get(0).style.opacity = "1";
    // this.h5().get(0).style.scale = "4";
  }
  hideH5() {
    if (this.h5().length < 1) return;
    this.h5().removeClass("show");
    // this.h5().get(0).style.transition = "";
    // this.h5().get(0).style.visibility = "hidden";
    // this.h5().get(0).style.opacity = "0";
    // this.h5().get(0).style.scale = "1";
  }
  imageEl() {
    if (!this.image()) {
      console.error("Slide#imageEl() No image elemenet found! el:", this.el);
      return;
    }
    return this.image().get(0);
  }
  showImage() {
    if (!this.imageEl()) {
      return;
    }
    this.imageEl().src = this.imageEl().dataset.src;
  }
  hideImage() {
    this.imageEl().src = "";
  }
  activate() {
    // console.log("Slide#activate()", this.h1().get(0));
    this.el.addClass("active");
    this.showImage();
    this.showH1();
    this.showH5();
  }
  deactivate() {
    this.el.removeClass("active");
    this.hideImage();
    this.hideH1();
    this.hideH5();
  }
}

export default Slide;
