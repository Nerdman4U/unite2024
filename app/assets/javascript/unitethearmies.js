import RecentVotes from RAILS_ASSET_URL("./unitethearmies/recent-votes.js");
import SlideShowContainer from RAILS_ASSET_URL("./unitethearmies/slideshowcontainer.js");
import Header from RAILS_ASSET_URL("./unitethearmies/header.js");

class UniteTheArmies {
  constructor() {
    this.recent_votes = new RecentVotes();
    this.slideshowcontainers = [];
    this.header = new Header();
  }

  load() {
    this.loadSlideShowContainers();
  }

  init() {
    this.loadVotes();
    this.removeSliderLoader();
    this.initSlideShowContainers()
  }

  initSlideShowContainers() {
    for (let c of this.slideshowcontainers) {
      c.init()
    }
  }

  loadSlideShowContainers() {
    let result =  $(".slideshow-container").map(function(index, el) {
      let cont = new SlideShowContainer($(el));
      cont.load()
      return cont
    })
    console.log('UniteTheArmies#SlideShowContainers', result)
    this.slideshowcontainers = result;
    return result
  }

  loadVotes() {
    this.recent_votes.loadVotes();
  }

  removeSliderLoader() {
    let loader = $(".tm-loader")
    loader.length && loader.remove()
  }

  isFullscreenSlider() {
    return $(".unite-slider-container").first() &&
      $(".unite-slider-container").first().hasClass("unite-screenheight-100")
  }

  /** Toggle slider height
   *
   * - Skip landing page
   * - If full screen slider, only hide caption (to allow see landscape image)
   * - If not full screen slider, show full screen without caption
   *
   */
  toggleSliderHeight() {
    let slider = $(".unite-slider-container").first();
    if (!slider.length) {
      console.log('Not found');
      return
    }

    if (slider.hasClass("unite-screenheight-100") && slider.hasClass("unite-landing")) {}
    else if (slider.hasClass("unite-screenheight-100")) {
      this.setSlideCaptions({"opacity": 0})
    } else {
      slider.addClass("unite-screenheight-100");
      this.setSlideCaptions({"opacity": 0})
    }
    // this.removeSliderLoader();
  }

  get comment () {
    return this.data.comment;
  }

  toggleHeaderBackground() {
    if ($(window).scrollTop() > $(".header").height()) {
      $('.header').addClass('header-background');
    } else {
      $('.header').removeClass('header-background');
    }
  }
}

export default UniteTheArmies;
