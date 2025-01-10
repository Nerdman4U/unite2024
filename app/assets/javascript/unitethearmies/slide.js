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
  elem() {
    return this.el;
  }
  activate() {
    console.log("Slide#activate()");
    this.elem().addClass("active");
  }
  deactivate() {
    this.elem().removeClass("active");
  }
}

class SlideWithImage extends Slide {
  constructor(decorated) {
    super();
    this.decorated = decorated;
    this.createImage();
  }
  elem() {
    return this.decorated.elem();
  }
  activate() {
    console.log("SlideWithImage#activate()");
    this.showImage();
    this.decorated.activate();
  }
  deactivate() {
    this.hideImage();
    this.decorated.deactivate();
  }

  /**
   * Create image
   *
   * If image src is given as data attribute create element here.
   *
   * @returns [elem] $(img) or null
   * */
  createImage() {
    let image_src = this.elem().data("imageSrc");
    console.log("SlideWithImage#createImage()", image_src);
    if (!image_src) {
      return;
    }
    let img = $("<img>");
    img.get(0).src = image_src;
    console.log("SlideWithImage#createImage()", image_src, img);
    this.elem().append(img);
    return img;
  }

  /** Image
   *
   * Find image under list item.
   *
   * @returns [elem] $(img) or null
   */
  image() {
    return this.elem().find("img");
  }

  imageEl() {
    if (!this.image()) {
      console.error("Slide#imageEl() No image element found! el:", this.elem());
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
}

class SlideWithHeaders extends Slide {
  constructor(decorated) {
    super();
    this.decorated = decorated;
    console.log("SlideWithHeaders");
  }
  elem() {
    return this.decorated.elem();
  }
  activate() {
    console.log("SlideWithHeaders#activate()");
    this.showH1();
    this.showH5();
    this.decorated.activate();
  }
  deactivate() {
    this.hideH1();
    this.hideH5();
    this.decorated.deactivate();
  }
  h1() {
    return this.elem().find("h1");
  }
  h5() {
    return this.elem().find("h5");
  }
  showH1() {
    if (this.h1().length < 1) return;
    this.h1().get(0).style.transition = this.h1().get(0).dataset.transition;
    this.h1().addClass("show");
  }
  hideH1() {
    if (this.h1().length < 1) return;
    this.h1().removeClass("show");
  }
  showH5() {
    if (this.h5().length < 1) return;
    this.h5().get(0).style.transition = this.h5().get(0).dataset.transition;
    this.h5().addClass("show");
  }
  hideH5() {
    if (this.h5().length < 1) return;
    this.h5().removeClass("show");
  }
}

export { Slide, SlideWithHeaders, SlideWithImage };
