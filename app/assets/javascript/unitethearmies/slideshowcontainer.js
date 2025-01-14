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
    this.el = $(el)
    this.current = 1;
    this.slideshows = $([]);
    this.el.on('click', this.toggleSize.bind(this))
  }

  toggleSize() {
    let classes = this.el.attr('class').split(' ')
    if (classes.indexOf('unite-screenheight-50') > -1) {
      this.el.removeClass('unite-screenheight-50')
      this.el.addClass('unite-screenheight-100')
    }
    else {
      this.el.removeClass('unite-screenheight-100')
      this.el.addClass('unite-screenheight-50')
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
    return this.el.find('.slideshow-headers')
  }

  initSlideShows() {
    this.slideshows.each(function(index, slideshow) { slideshow.init() })
  }

  loadSlideShows() {
    let decorators = []
    if (this.el.find('.slider-nav').length > 0) {
      decorators.push('nav1')
    }
    if (this.el.data('decorators')) {
      let dec = this.el.data("decorators").split(",").map(function(e) { return $.trim(e) }) || []
      decorators = decorators.concat(dec)
    }
    //console.log('SlideShowContainer#loadSlideShows() decorators', decorators, this.el)
    let slideshows = this.el.find(".slideshow").map(function(index, el) {
      let slideShow = new SlideShow($(el))
      for (let decorator of decorators) {
        console.log('SlideShowContainer#loadSlideShows() deco:', decorator)
        switch (decorator) {
          case 'nav1':
            slideShow = new SlideShowButtons(slideShow);
            break;
          case 'carousel':
            slideShow = new SlideShowCarusel(slideShow);
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
  slideShow(nro) {
    let el = this.el.find(".slideshow:first-child"); // <ul> element
    if (el.length < 1) {
      console.error("SlideShows#slideShow() slideShow not found!");
      return;
    }
    if (!el) {
      console.error("SlideShow#slideShow() No element")
      return;
    }
    let slideshow =  new SlideShow(el);
    slideshow.showButtons();
    return slideshow
  }

  show() {
    this.el.show();
  }

  hide() {
    this.el.hide();
  }

  next() {}
  prev() {}
}

export default SlideShowContainer;
