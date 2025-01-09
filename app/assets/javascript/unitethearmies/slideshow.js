class Slide {
  /**
   * @param {*} el <li> element
   */
  constructor(el) {
    this.el = el;
  }
  activate() {
    this.el.addClass("active");
  }
  deactivate() {
    this.el.removeClass("active");
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
    this.current_slide = this.slides[0];
  }

  /** Proceed
   *
   * Select a slide.
   *
   * @param {int} nro offset, -1 prev, +1 next
   * @return {Slide}
   */
  proceed(nro) {
    nro = parseInt(nro);
    if (!nro) nro = 0;
    let slide_nro = (this.current_nro += nro);
    if (!slide_nro) slide_nro = 1;
    if (slide_nro < 1) slide_nro = 1;
    if (slide_nro > this.slides.length) slide_nro = this.slides.length;
    // console.log(slide_nro);
    // let li = this.el.children(`li:nth-child(${slide_nro})`);
    // if (li.length < 1) {
    //   console.error("SlideShow#showButtons() Slideshow not found!");
    //   return;
    // }
    this.current_nro = slide_nro;
    this.current_slide = this.slides[slide_nro - 1];
    return this.current_slide;
  }

  deactivate() {
    console.log(this.slides);
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
            this.current_slide.activate();
            console.log(this.current_nro);
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
