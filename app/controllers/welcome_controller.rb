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
          alt: _(""),
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
          alt: _("Wildlife park wolf by Wolfgang65"),
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
    @slider = Slider.new({
      name: "why_vote",
      fullscreen: true,
      navigation: false,
      type: "carousel",
      decorators: ["carousel"],
      slides: [{
        name: "earth-01",
        headers: {
          h1: [_("This is our home planet")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 2458],
        type: 'jpg',
        default: 1024,
        alt: _("Earth"),
        decorators: ["headers", "image"]
      },{
        name: "earth-01",
        headers: {
          h1: [_("We all live here")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 2458],
        type: 'jpg',
        default: 1024,
        alt: _("Earth"),
        decorators: ["headers", "image"]
      },{
        name: "milky_way",
        headers: {
          h1: [_("Around us is 400 billion solar systems.")],
          h2: [_("This is our home Galaxy, Milky Way.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000, 6000, 7000, 8262],
        type: 'jpg',
        default: 1024,
        alt: _("Milky way"),
        decorators: ["headers", "image"]
      },{
        name: "galaxy",
        headers: {
          h1: [_("Our galaxy is in infinite space. The Universe.")],
          h2: [_("All light comes from distant stars, like our home sun.")],
        },
        res: [512, 640, 960, 1024, 1280, 1920, 2048, 3072, 4000, 5000, 5257],
        type: 'jpg',
        default: 1024,
        alt: _("Constellations"),
        decorators: ["headers", "image"]
      }]
    })
  end
end
