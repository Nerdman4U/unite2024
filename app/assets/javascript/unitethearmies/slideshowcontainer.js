import SlideShow from RAILS_ASSET_URL('slideshow.js')

/**
 * SlideShowContainer
 *
 * A section or div element containing one more more lists.
 *
 */
class SlideShowContainer {
  constructor(el) {
    this.el = $(el)
    this.current = 1; // first slideshow container <ul> below this.el.
    this.loadSlideShows()
  }

  init() {
    this.initSlideShows()
  }

  slideShows() {
    return this.el.find(".slideshow").map(function(index, el) {
      return new SlideShow($(el))
    })
  }
  loadSlideShows() {
    this.slideshows = this.slideShows()
  }
  initSlideShows() {
    this.slideshows.each(function(index, slideshow) { slideshow.init() })
  }

  /**
   *
   * @param {*} nro
   * @returns
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
