import { SlideShow, SlideShowCarusel, SlideShowButtons } from RAILS_ASSET_URL('slideshow.js')

/**
 * public: SlideShowContainer.
 *
 * A section or div element containing one more more lists. Each list will be
 * SlideShow and list items Slides.
 */
class SlideShowContainer {

  /**
   * public: constructor.
   *
   * el      - root element, $(<ul>).
   * current - order number, starting from 1.
   */
  constructor(el) {
    this._el = $(el)
    this._current_nro = 1;
    this._current = null;
    this.slideshows = $([]);
    this.elem().on('click', this.toggleSize.bind(this))
  }
  elem() { return this._el }
  toggleSize() {
    let classes = this.elem().attr('class').split(' ')
    if (classes.indexOf('unite-screenheight-50') > -1) {
      this.elem().removeClass('unite-screenheight-50')
      this.elem().addClass('unite-screenheight-100')
    }
    else {
      this.elem().removeClass('unite-screenheight-100')
      this.elem().addClass('unite-screenheight-50')
    }

    console.log('SlideShowContainer#toggleSize()', classes)
    for (let slideshow of this.slideshows) {
      slideshow.hideButtons && slideshow.hideButtons()
    }
  }

  /**
   * public: create SlideShow instances.
   */
  load() {
    this.loadSlideShows()
  }

  /**
   * public: initialize this object.
   *
   * Currently only initialize created SlideShow instances.
   */
  init() {
    this.initSlideShows()
    if (this.headers().length > 0) this.headers().addClass('active')
  }
  headers() {
    return this.elem().find('.slideshow-headers')
  }

  initSlideShows() {
    this.slideshows.each(function(index, slideshow) { slideshow.init() })
  }

  loadSlideShows() {
    let decorators = []
    if (this.elem().find('.slider-nav').length > 0) {
      decorators.push('nav1')
    }
    if (this.elem().data('decorators')) {
      let dec = this.elem().data("decorators").split(",").map(function(e) { return $.trim(e) }) || []
      decorators = decorators.concat(dec)
    }
    // console.log('SlideShowContainer#loadSlideShows() decorators', decorators, this.el)
    let obj = this;
    let slideshows = this.elem().find(".slideshow").map(function(index, el) {
      // console.log('SlideShowContainer#loadSlideShows() el:', el, 'this:', obj)
      let slideShow = new SlideShow($(el), obj)
      let interval = $(el).data('interval') || 5000
      for (let decorator of decorators) {
        // console.log('SlideShowContainer#loadSlideShows() deco:', decorator)
        switch (decorator) {
          case 'nav1':
            slideShow = new SlideShowButtons(slideShow);
            break;
          case 'carousel':
            slideShow = new SlideShowCarusel(slideShow, {interval: interval});
            break;
        }
      }
      slideShow.load()
      return slideShow;
    })
    this.slideshows = slideshows;
    return slideshows;
  }

  /**
   * public: Create slideshow.
   *
   * nro - order number starting from 1.
   *
   * Returns SlideShow.
   */
  // slideShow(nro) {
  //   let el = this.el.find(".slideshow:first-child"); // <ul> element
  //   if (el.length < 1) {
  //     console.error("SlideShows#slideShow() slideShow not found!");
  //     return;
  //   }
  //   if (!el) {
  //     console.error("SlideShow#slideShow() No element")
  //     return;
  //   }
  //   let slideshow =  new SlideShow(el, this);
  //   slideshow.showButtons();
  //   return slideshow
  // }

  show() {
    // TODO: If there is ever need to have many slideshows under same container.
    this._current = this.slideshows[this._current_nro - 1];
    this.elem().show();
  }

  hide() {
    this.elem().hide();
  }

  next() {}
  prev() {}
}

export default SlideShowContainer;
