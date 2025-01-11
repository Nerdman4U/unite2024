import { Slide, SlideWithHeaders, SlideWithImage } from RAILS_ASSET_URL('slide.js')

/**
 * public: SlideShow.
 *
 * SlideShow root element is <ul> and contains Slides
 * <li> elements. SlideShow and Slide instances can be created
 * using decorators.
 *
 */
class SlideShow {
  /**
   * public: Constructor for SlideShow.
   *
   * name          - Just for testing.
   * el            - <ul>- jQuery element.
   * current_nro   - Order number of current slide.
   * current_slide - Slide.
   * decorated     - Slidable instance if decorated later.
   */
  constructor(el) {
    this.name = "core"
    this.el = $(el); // <ul> element
    this.current_nro = 1; // 1.st child
    this.current_slide = null;
    this.slides = $([]);
    this.decorated = this
  }

  /**
   * public: return root element.
   *
   * Returns nothing.
   */
  elem() { return this.el }

  /**
   * public: returns SlideShow base class instance when called
   * from decorators.
   *
   * Returns SlideShow.
   */
  deco() { return this.decorated }

  /**
   * public: Creates Slide instances with decorators.
   *
   * Returns nothing.
   */
  load() {
    this.loadSlideShow();
  }

  /**
   * public: Initializes created instances.
   *
   * This must be called after load.
   *
   * Returns nothing.
   */
  init() {
    if (this.slides.length < 1) {
      console.error("SlideShow#init No slides!");
      return;
    }
    this.slides.each(function(index, slide) { slide.init() })
    this.setCurrentSlide(0);
  }


  /** deprecated: Slide decorators
   *
   * TODO: refactor based on html
   *
   * Returns an array of strings.
   */
  decorators() {
    return this.elem().data('decorators') || []
  }

  /**
   * public: instantiate Slide classes.
   *
   * TODO: decorators could work automatically by searching
   * child nodes and decorating based on elements found.
   *
   * Returns nothing.
   */
  loadSlideShow() {
    this.elem().children("li").each(
      function (index, el) {
        let slide = new Slide($(el));
        if (this.decorators().indexOf('headers') > -1) {
          slide = new SlideWithHeaders(slide)
        }
        if (this.decorators().indexOf('image') > -1) {
          slide = new SlideWithImage(slide)
        }
        this.slides.push(slide);
      }.bind(this)
    );
  }

  /**
   * public: Set current slide
   *
   * nro - An integer. An order number of a slide.
   *
   * Returns nothing.
   */
  setCurrentSlide(nro) {
    this.current_slide = this.slides[nro];
    this.current_slide.activate();
  }

  /** public: Show new slide.
   *
   * offset - An integer. A number to find next slide, -1 for previous
   *          slide, 1 for next slide.
   *
   * Returns the current Slide.
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

  /**
   * public: deactivate current SlideShow.
   *
   * All Slide element displays are set to none.
   *
   * Returns nothing.
   */
  deactivate() {
    // console.log("Deactivate()", this.slides);
    this.slides.each(function (index, slide) {
      console.log(slide);
      slide.deactivate();
    });
  }
}

/**
 * public: Carusel decorator.
 *
 * Carusel adds image change based on timer.
 */
class SlideShowCarusel extends SlideShow {
  constructor(decorated) {
    super();
    this.name = "carusel"
    this.decorated = decorated
  }
  deco() { return this.decorated }
  elem() { return this.deco().elem() }
  load() {
    this.deco().load()
  }
  init() {
    this.deco().init()
  }
}

/**
 * public: Buttons decorator.
 *
 * Adds navigation buttons to the left and right side of current slideshow
 * image. Under root element .slider-nav objects are to be found.
 */
class SlideShowButtons extends SlideShow {

  constructor(decorated) {
    super();
    this.name = "buttons"
    this.decorated = decorated
  }
  deco() { return this.decorated }
  elem() {
    return this.deco().elem()
  }
  load() {
    this.deco().load()
  }

  init() {
    this.deco().init()
    this.initButtons();
    this.showButtons();
  }
  buttons() {
    console.log('SlideShowButtons#buttons()')
    let buttons = this.elem().find(".slider-nav");
    if (buttons.length < 1) {
      console.error("SlideShow#showButtons() Slideshow buttons not found!");
      return;
    }
    return buttons;
  }

  initButtons() {
    if (!this.buttons()) return
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
    if (!this.buttons()) return
    this.buttons().each(function (index, el) {
      $(el).show();
    });
  }

  hideButtons() {
    if (!this.buttons()) return
    this.buttons().each(function (index, el) {
      $(el).hide();
    });
  }

}

export { SlideShow, SlideShowCarusel, SlideShowButtons }
