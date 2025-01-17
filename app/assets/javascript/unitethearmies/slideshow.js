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
   * current_nro   - Order number of current slide, first is 1.
   * current_slide - Slide.
   * decorated     - Slidable instance if decorated later.
   */
  constructor(el) {
    this._name = "core"
    this.el = $(el);
    this.current_nro = 1;
    this._current_slide = $();
    this._slides = $([]);
    this.decorated = this
  }

  /**
   * public: return root element.
   *
   * Returns nothing.
   */
  elem() { return this.el }
  currentSlide() { return this._current_slide; }
  name() { return this._name }

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
    if (this.slides().length < 1) {
      console.error("SlideShow#init No slides!");
      return;
    }
    this.slides().each(function(index, slide) { slide.init() })

    this.proceed(0)
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
        // TODO: new Slide($(el), slide_options) <= mis o nää?
        let slide = new Slide($(el));
        let decorators = $(el).data('decorators') || []
        // console.log('SlideShow#loadSlideShow() decorators:', decorators)
        // decorators = $(decorators)
        // console.log('SlideShow#loadSlideShow() decorators[0]:', decorators[0])
        // => undefined (?)

        if (decorators.indexOf('headers') > -1) {
          slide = new SlideWithHeaders(slide)
          console.log('SlideShow#loadSlideShow() headers!')
        }
        if (decorators.indexOf('image') > -1) {
          slide = new SlideWithImage(slide)
        }
        this._slides.push(slide);
      }.bind(this)
    );
  }

  slides() {
    return this._slides;
  }

  /** public: Show new slide.
   *
   * offset - An integer. A number to find next slide, -1 for previous
   *          slide, 1 for next slide.
   *
   * Returns nothing.
   */
  proceed(offset) {
    offset = parseInt(offset);
    if (!offset) offset = 0;
    let slide_nro = (this.current_nro += offset);
    if (!slide_nro) slide_nro = 1;
    if (slide_nro < 1) slide_nro = 1;
    if (slide_nro > this.slides().length) slide_nro = 1
    console.log("SlideShow#proceed()", slide_nro, offset);
    this.current_nro = slide_nro;
    this.setCurrentSlide(slide_nro);
  }

  /**
   * public: Set and activates current slide. Use proceed instead.
   *
   * nro - An integer. An order number of a slide.
   *
   * Returns nothing.
   */
  setCurrentSlide(nro) {
    console.log('SlideShow#setCurrentSlide() nro:', nro)
    this.deactivateSlides()
    this._current_slide = this.slides()[nro-1];
    this._current_slide.activate();
    console.log('SlideShow#setCurrentSlide() currentSlide():', this.currentSlide().el.get(0))
  }

  deactivateSlides() {
    for (let slide of this.slides()) {
      slide.deactivate()
    }
  }

  /**
   * public: deactivate current SlideShow.
   *
   * All Slide element displays are set to none.
   *
   * Returns nothing.
   */
  deactivate() {
    console.log("SlideShow#deactivate()", this.slides());
    this.slides().each(function (index, slide) {
      slide.deactivate();
    });
  }
}

/**
 * public: Carusel decorator.
 *
 * Changes images on 5s interval.
 *
 * TODO: more options.
 */
class SlideShowCarusel extends SlideShow {
  constructor(decorated, options={}) {
    super();
    this._name = "carusel"
    this.decorated = decorated
    this._options = options;
    console.log('SlideShowCarusel()')
  }
  deco() { return this.decorated }
  elem() { return this.deco().elem() }
  name() { return this._name }
  load() {
    this.deco().load()
  }
  interval() { return this._options.interval || 5000 }
  init() {
    this.deco().init()
    window.timers.register(this.interval(), function() { this.run() }.bind(this) )
  }
  run() {
    this.proceed(1)
   }
  slides() {
    return this.deco().slides()
  }
  currentSlide() {
    return this.deco().currentSlide()
  }
  setCurretSlide(nro) {
    return this.deco().setCurrentSlide(nro)
  }
  proceed(nro) {
    return this.deco().proceed(nro)
  }
  deactivateSlides() {
    return this.deco().deactivateSlides()
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
    this._name = "buttons"
    this.decorated = decorated
  }
  deco() { return this.decorated }
  elem() {
    return this.deco().elem()
  }
  name() { return this._name }
  load() {
    this.deco().load()
  }
  slides() {
    return this.deco().slides()
  }
  currentSlide() {
    return this.deco().currentSlide()
  }
  setCurretSlide(nro) {
    return this.deco().setCurrentSlide(nro)
  }
  proceed(nro) {
    return this.deco().proceed(nro)
  }
  deactivateSlides() {
    return this.deco().deactivateSlides()
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
