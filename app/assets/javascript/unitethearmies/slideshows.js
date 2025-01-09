import SlideShow from RAILS_ASSET_URL('slideshow.js')

// May contain multiple slideshows with each having multiple slides.
class SlideShows {
  constructor() {
    this.el = $(".tm-slider-container");
    this.current = 1; // first slideshow container <ul> below this.el.
    this.init()
  }
  init() {
    this.slideshow = this.slideShow(this.current);
  }
  // @return array of slide shows under container.
  slideShow(nro) {
    let el = this.el.find(".tms-slides:first-child"); // <ul> element
    if (el.length < 1) {
      console.error("SlideShows#slideShow() slideShow not found!");
      return;
    }
    let slideshow =  new SlideShow(el);
    slideshow.showButtons();
    return slideshow
  }
  show() {
    $(".unite-slider-container").show();
  }
  hide() {
    $(".unite-slider-container").hide();
  }
  next() {}
  prev() {}
}

export default SlideShows;
