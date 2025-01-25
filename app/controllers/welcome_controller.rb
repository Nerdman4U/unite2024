# coding: utf-8

class WelcomeController < ApplicationController

  ## public: landing page.
  #
  # Javascript Decorator info:
  #
  # Slider is a javascript object connected to html element. Slider structure
  # is defined with helper_method using Slider ruby class instances.
  #
  # TODO: move somewhere.
  # TODO: decorators should be read from element properties etc.
  #
  # Slider decorators:
  # - nav1
  # - carousel
  # - new: headers ( visible at all slides )
  # Slide decorators:
  # - headers
  # - images
  #
  # Returns index view.
  def index
    @welcome_slider = Slider.new({
      name: "welcome",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "seascape",
        headers: {
          h1: [_("Save the planet")],
          h2: [_("Give the armies a new, positive task: protect the environment")]
        },
        res: [640,960,1024,1280,1920,2048,3072,4096],
        type: 'jpg',
        default: 640,
        alt: _(UNITE_TITLE),
        decorators: ["headers", "image"]
      }]
    })

    options = {
      name: "welcome-carousel",
      fullscreen: true,
      type: "carousel",
      decorators: ["carousel"],
      navigation: false,
      autoplay: true,
      autoplayspeed: 8000,
      showplaysndpause: true,
      headers: {
        h1: [_("First Aid")],
        h2: [_("To Our Common World")],
        h3: [_("There is a hidden potential at hand: the national armies.")]
      },
      slides: [
        {
          name: "tickseed",
          res: [640,960,1024,1280,1920,2048,3072,4000,4710],
          type: 'jpg',
          default: 1024,
          alt: _("Tickseed Careopsis Calliopsis by JamesDeMers"),
          decorators: ["image"]
        },
        {
          name: "forest",
          res: [640,960,1024,1280,1920,2048],
          type: 'jpg',
          default: 1024,
          alt: _("Woodland forest moss sunset by TheOtherKev"),
          decorators: ["image"]
        },
        {
          name: "avaruus",
          res: [640,960,1024,1280,1920,2048],
          type: 'jpg',
          default: 1024,
          alt: _("Stars on the horizon"),
          decorators: ["image"]
        },
        {
          name: "talvi18",
          res: [640,960,1024,1280,1920,2048],
          type: 'jpg',
          default: 1024,
          alt: _("Snowy landscape from Finland"),
          decorators: ["image"]
        },
        {
          name: "autumn-shore",
          res: [640,960,1024,1280,1920,2048],
          type: 'jpg',
          default: 1024,
          alt: _("Autumn shore"),
          decorators: ["image"]
        },
        {
          name: "woodland",
          res: [640,960,1024,1280,1920,2048,3072,4500],
          type: 'jpg',
          default: 1024,
          alt: _("Woodland forest moss sunset by TheOtherKev"),
          decorators: ["image"]
        },
        {
          name: "sunrise-on-the-sea",
          res: [640,960,1024,1280,1920,2048],
          type: 'jpg',
          default: 1024,
          alt: _("Sunrise on the sea"),
          decorators: ["image"]
        }
      ]
    }
    @welcome_carousel = Slider.new(options)
  end

  def initiative
  end

  def appeal
    @slider = Slider.new({
      name: "appeal",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "tyyni-jarvenselka",
        headers: {
          h1: [_("First Aid")],
          h2: [_("To Our Common World")]
        },
        res: [2048],
        type: 'jpg',
        default: 2048,
        alt: _(UNITE_TITLE),
        decorators: ["headers", "image"]
      }]
    })
  end

  def material
    @slider = Slider.new({
      name: "material",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "desert-plants",
        headers: {
          h1: [_("Download")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048],
        type: 'jpg',
        default: 1024,
        alt: _("Desert plants"),
        decorators: ["headers", "image"]
      }]
    })
  end

  def why_vote
    unless session[:fullscreen_info_seen]
      flash.now[:info] = [_("For optimal experience please use F11 to allow full screen mode :bi-emoji-smile-fill:.")]
      session[:fullscreen_info_seen] = true
    end
    earth_pics = [
      { name:"earth-02", res: [512, 640, 960, 1024, 1280, 1920, 2048, 3000] },
      { name:"earth-03", res: [512, 640, 960, 1024, 1280, 1920, 2048, 2500] },
      { name:"earth-04", res: [512, 640, 960, 1024, 1280, 1920, 2048, 3000] },
      { name:"earth-05", res: [512, 640, 960, 1024, 1280, 1920, 2048] }
    ]
    earth_pic = earth_pics.sample

    @slider = Slider.new({
      name: "why_vote",
      fullscreen: true,
      navigation: false,
      type: "carousel",
      decorators: ["carousel","nav1"],
      autoplay: true,
      autoplay_speed: 12000,
      show_play_and_pause: true,
      start_fullscreen: true,
      show_fullscreen_buttons: true,
      show_next_and_previous: true,
      slides: [{
        name: earth_pic[:name],
        headers: {
          h1: [_("This is our home planet.")],
          h2: [_("The Earth: third planet from the sun.")]
        },
        res: earth_pic[:res],
        type: 'jpg',
        default: 1024,
        alt: _("Earth"),
        decorators: ["headers", "image"]
      },{
        name: "earth-01",
        headers: {
          h1: [_("We all live here.")],
          h2: [_("All people in the universe reside on this planet."), _("Also, all animals and plants live here."), _("Microbes live here too :)")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 2458],
        type: 'jpg',
        default: 1024,
        alt: _("Earth"),
        decorators: ["headers", "image"]
      },{
        name: "milky_way",
        css: { classes: ["text-light"] },
        headers: {
          h1: [_("Around us are 400 billion solar systems.")],
          h2: [_("The Milky Way - OUR Galaxy.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000, 6000, 7000, 8262],
        type: 'jpg',
        default: 1024,
        alt: _("Milky way"),
        decorators: ["headers", "image"]
      },{
        name: "galaxy",
        headers: {
          h1: [_("The Universe.")],
          h2: [_("There are billions of galaxies in the Universe.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000, 5257],
        type: 'jpg',
        default: 1024,
        alt: _("Constellations"),
        decorators: ["headers", "image"]
      },{
        name: "blank",
        css: { classes: ["text-dark"] },
        headers: {
          h1: [_("There are huge"), _("environmental"), _("problems on our home planet.")],
        },
        res: [],
        default: 1024,
        decorators: ["headers", "image"]
      },{
        name: "mining-01",
        headers: {
          h1: [_("We are misusing our home planet...")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000, 6000],
        type: 'jpg',
        default: 1024,
        alt: _("Mining"),
        decorators: ["headers", "image"]
      },{
        name: "trash-01",
        headers: {
          h1: [_("...and by doing that we create...")],
          h2: [_("Trash..."), _("Pollution..."), _("Warm climate and oceans..."), _("Increase deforestation...")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 4128],
        type: 'jpg',
        default: 1024,
        alt: _("Trash, plastics"),
        decorators: ["headers", "image"]
      },{
        name: "overpopulation",
        css: { classes: ["text-dark"] },
        headers: {
          h1: [_("There are more humans than ever before.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000],
        type: 'jpg',
        default: 1024,
        alt: _("Overpopulation"),
        decorators: ["headers", "image"]
      },{
        name: "population-graph",
        css: { classes: ["text-dark"] },
        headers: {
          h1: [_("We have grown"), _("beyond sustainable limits!")],
        },
        type: 'svg',
        alt: _("Overpopulation"),
        decorators: ["headers", "image"]
      },{
        name: "monkey",
        headers: {
          h1: [_("...just by living our lives... ")],
          h2: [_("...we destroy homes of others...")]
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 3840],
        type: 'jpg',
        default: 1024,
        alt: _("Monkey mother and baby"),
        decorators: ["headers", "image"]
      },{
        name: "forest-02",
        headers: {
          h1: [_("We can change things."), _("We made them."), _("We fix.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 4879],
        type: 'jpg',
        default: 1024,
        alt: _("Trees"),
        decorators: ["headers", "image"]
      },{
        name: "blank",
        css: { classes: ["text-dark"] },
        headers: {
          h1: [_("Our home is the only planet with life.")],
          h2: [_("We are destroying it.")],
        },
        res: [],
        type: 'jpg',
        default: 1024,
        alt: _("Trees"),
        decorators: ["headers", "image"]
      },{
        name: "blank",
        css: { classes: ["text-dark"] },
        headers: {
          h1: [_("You can help.")],
          h2: [_("Vote for the initiative presented on this site.")],
        },
        res: [],
        type: 'jpg',
        default: 1024,
        alt: _("Trees"),
        decorators: ["headers", "image"]
      }]
    })
  end
end
