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
    // console.log("Slide#showH1() 1", this.h1().get(0));
    this.h1().get(0).style.transition = this.h1().get(0).dataset.transition;
    this.h1().get(0).style.visibility = "visible";
    this.h1().get(0).style.opacity = "1";
    // console.log("Slide#showH1() 2", this.h1().get(0));
  }
  hideH1() {
    // console.log("Slide#hideH1() 1", this.h1().get(0));
    this.h1().get(0).style.transition = "";
    this.h1().get(0).style.visibility = "hidden";
    this.h1().get(0).style.opacity = "0";
    // console.log("Slide#hideH1() 2", this.h1().get(0));
  }
  showH5() {
    this.h5().get(0).style.transition = this.h5().get(0).dataset.transition;
    this.h5().get(0).style.visibility = "visible";
    this.h5().get(0).style.opacity = "1";
  }
  hideH5() {
    this.h5().get(0).style.transition = "";
    this.h5().get(0).style.visibility = "hidden";
    this.h5().get(0).style.opacity = "0";
  }
  imageEl() {
    return this.image().get(0);
  }
  showImage() {
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
/**
 * SlideShow
 *
 * Main element is <ul> under slideshow container element.
 * Contains multiple slides as <li> elements.
 *
 */
class SlideShow {
  /**
   * @el [element] <ul> containing all slides.
   * @current [integer] order number 1+
   *
   * @param {*} el
   */
  constructor(el) {
    this.el = el; // <ul> element
    this.current_nro = 1; // 1.st child
    this.current_slide = null;
    this.slides = $([]);
    this.init();
    this.initButtons();
  }

  init() {
    this.el.children("li").each(
      function (index, el) {
        let slide = new Slide($(el));
        this.slides.push(slide);
      }.bind(this)
    );
    if (this.slides.length < 1) {
      console.error("SlideShow#init No slides!");
      return;
    }
    this.setCurrentSlide(0);
  }

  /**
   * Set current slide
   *
   * Set variable and activate.
   * @param {int} nro
   */
  setCurrentSlide(nro) {
    this.current_slide = this.slides[nro];
    this.current_slide.activate();
  }

  /** Proceed
   *
   * Select a slide.
   *
   * @param {int} nro offset, -1 prev, +1 next
   * @return {Slide}
   */
  proceed(offset) {
    offset = parseInt(offset);
    if (!offset) offset = 0;
    let slide_nro = (this.current_nro += offset);
    if (!slide_nro) slide_nro = 1;
    if (slide_nro < 1) slide_nro = 1;
    if (slide_nro > this.slides.length) slide_nro = this.slides.length;
    // console.log("SlideShow#proceed()", slide_nro, offset);
    this.current_nro = slide_nro;
    this.setCurrentSlide(slide_nro - 1);
    return this.current_slide;
  }

  deactivate() {
    // console.log("Deactivate()", this.slides);
    this.slides.each(function (index, slide) {
      console.log(slide);
      slide.deactivate();
    });
  }

  buttons() {
    let buttons = this.el.find(".slider-nav");
    if (buttons.length < 1) {
      console.error("SlideShow#showButtons() Slideshow buttons not found!");
      return;
    }
    return buttons;
  }

  initButtons() {
    this.buttons().each(
      function (index, el) {
        $(el).click(
          function (e) {
            e.preventDefault();
            this.deactivate(); // deactivate all slides.
            this.proceed(el.dataset.offset); // select new slide.
            if (!this.current_slide) {
              console.error("SlideShow#initButtons click: No Slide!");
              return;
            }
          }.bind(this)
        );
      }.bind(this)
    );
  }

  showButtons() {
    this.buttons().each(function (index, el) {
      $(el).show();
    });
  }

  hideButtons() {
    this.buttons().each(function (index, el) {
      $(el).hide();
    });
  }
}

export default SlideShow;
