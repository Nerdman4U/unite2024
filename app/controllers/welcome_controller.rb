# coding: utf-8

class WelcomeController < ApplicationController
  # *************  ✨ Codeium Command ⭐  *************/
  # The index action serves as the main entry point for the WelcomeController,
  # rendering the default view for the homepage.
  # ******  8b1714b4-b23a-40eb-aa2c-57929f5a2dce  *******/
  def index
    @welcome_slider = Slider.new({
      name: "welcome",
      fullscreen: true,
      carousel: false,
      navigation: false,
      slides: [{
        name: "seascape",
        h1: _("Save the planet"),
        h5: _("Give the armies a new, positive task: protect the environment"),
        res: [640,960,1024,1280,1920,2048,3072,4096],
        type: 'jpg',
        default: 640,
        alt: _(UNITE_TITLE)
      }]
    })
  end

  def appeal
  end

  def material
  end

end
