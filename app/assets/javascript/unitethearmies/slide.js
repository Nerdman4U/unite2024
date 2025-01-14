/**
 * public: This file contains Slide and Slide decorator classes.
 *
 * Decorators expand Slide when root element has elements to be used in
 * decorators. Methods to add functionality from data- attributes are
 * at Slide.
 */

class Slide {
  /**
   * public Slide constructor.
   *
   * el  - root $(element)
   */
  constructor(el) {
    this.el = $(el);
    this.obj = this;
  }

  deco() {
    return this.obj;
  }
  /**
   * public: Create elements from data attribute values.
   *
   * Returns nothing.
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
   * public: Create an image element and append it to root element.
   *
   * This method is used when image source is given as data attribute. If
   * data is missing, null is returned.
   *
   * Examples
   *
   *   el: <li data-image-src="path/to/my/image"></li>
   *   createImage() =>
   *   <li>
   *     <img src="path/to/my/image"/>
   *   </li>
   *
   * Returns $(img) or null.
   * */
  createImage() {
    let image_src = this.elem().data("imageSrc");
    if (!image_src) {
      return;
    }
    let img = $("<img>");
    img.get(0).src = image_src;
    // console.log("SlideWithImage#createImage()", image_src, img);
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

  /** public: Find img element.
   *
   * Returns an $(img) element.
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

  /**
   * public: make image available by setting src attribute.
   *
   * Returns nothing
   */
  showImage() {
    if (!this.imageEl()) return;
    // this.imageEl().src = this.imageEl().dataset.src;
    this.image().show();
  }
  hideImage() {
    if (!this.imageEl()) return;
    // this.imageEl().src = "";
    this.image().hide();
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
    // console.log("SlideWithHeaders#activate()");
    this.showHeader("h1");
    this.showHeader("h2");
    this.showHeader("h3");
    this.showHeader("h4");
    this.showHeader("h5");
    this.deco().activate();
  }
  deactivate() {
    this.hideHeader("h1");
    this.hideHeader("h2");
    this.hideHeader("h3");
    this.hideHeader("h4");
    this.hideHeader("h5");
    this.deco().deactivate();
  }

  showHeader(h) {
    let el = this.elem().find(h);
    if (el.length < 1) return;
    //this.h1().get(0).style.transition = this.h1().get(0).dataset.transition;
    el.addClass("show");
  }
  hideHeader(h) {
    let el = this.elem().find(h);
    if (el.length < 1) return;
    el.removeClass("show");
  }
}

export { Slide, SlideWithHeaders, SlideWithImage };
