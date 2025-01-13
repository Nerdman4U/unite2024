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
        name: "seashore"
      }]
    })
  end

  def appeal
  end

  def material
  end

end
