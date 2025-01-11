/**
 * Slides and Slide decorators.
 *
 * Decorators are to expand Slide structure with elements.
 *
 * Functionality from data- attributes are at base Slide class.
 */

class Slide {
  /**
   * @param {*} el $(<li>)
   */
  constructor(el) {
    this.el = el;
    this.obj = this;
  }

  deco() {
    return this.obj;
  }
  /** Create elements from data attribute values.
   *
   */
  create() {
    this.createImage();
  }

  init() {
    this.create();
  }
  elem() {
    return this.el;
  }
  activate() {
    // console.log("Slide#activate()");
    this.elem().addClass("active");
  }
  deactivate() {
    this.elem().removeClass("active");
  }

  /**
   * Create image
   *
   * If image src is given as data attribute create element here.
   *
   * <li data-image-src="path/to/my/image"></li>
   * =>
   * <li><img src="path/to/my/image"/></li>
   *
   * @returns [elem] $(img) or null
   * */
  createImage() {
    let image_src = this.elem().data("imageSrc");
    if (!image_src) {
      return;
    }
    let img = $("<img>");
    img.get(0).src = image_src;
    console.log("SlideWithImage#createImage()", image_src, img);
    this.elem().append(img);
    return img;
  }
}

class SlideWithImage extends Slide {
  constructor(decorated) {
    super();
    this.decorated = decorated;
  }
  deco() {
    return this.decorated;
  }
  elem() {
    return this.deco().elem();
  }
  activate() {
    console.log("SlideWithImage#activate()");
    this.showImage();
    this.deco().activate();
  }
  deactivate() {
    this.hideImage();
    this.deco().deactivate();
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
  deco() {
    return this.decorated;
  }
  elem() {
    return this.deco().elem();
  }
  activate() {
    console.log("SlideWithHeaders#activate()");
    this.showH1();
    this.showH5();
    this.deco().activate();
  }
  deactivate() {
    this.hideH1();
    this.hideH5();
    this.deco().deactivate();
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
