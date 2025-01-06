# -*- coding: utf-8 -*-

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    I18n.locale = :en
  end

  test "should have correct locale" do
    assert_equal :en, I18n.locale
    assert_equal :en, I18n.default_locale
    assert_equal "en", FastGettext.locale
    assert_equal "en", FastGettext.default_locale
    get locale_root_url locale: :ru
    assert_equal I18n.locale, :ru
    assert_equal FastGettext.locale, "ru" # FastGettext converts locale as a symbol to string...
    assert_equal session[:locale], :ru
  end

  test "should not allow wrong locale" do
    get locale_root_url locale: "foobar"
    assert_equal I18n.locale, :en
    get root_url locale: "foobar"
    assert_equal I18n.locale, :en
  end

  test "should have correct open graph protocol values" do
    get locale_root_url locale: :en

    assert_dom("meta[property='og:title']") { |elem| assert_equal elem.attr("content").value, "Home (Save the Planet - Unite the Armies)" }
    assert_dom "meta[property='og:type']" do |elem| assert_equal elem.attr("content").value, "website" end
    assert_dom "meta[property='og:url']" do |elem| assert_equal elem.attr("content").value, "http://www.example.com/en" end
    assert_dom "meta[property='og:image']" do |elem| assert_equal elem.attr("content").value, "http://www.example.com/assets/logo-8067e3b5.png" end
    assert_dom "meta[property='og:locale']" do |elem| assert_equal elem.attr("content").value, "en" end # assert_dom "meta[property='og:locale']", content: "en"
    assert_dom "meta[property='og:locale:alternate']" do |elems|
      assert_equal elems.length, Language::UI.locales.length
      elems.each do |elem|
        assert(Language::UI.locales.any? { |locale| elem.attr("content") == locale })
      end
      assert_not(["foobar","asdf"].any? { |locale| elems.attr("content") == locale })
    end
  end

  test "should detect production server" do
    get locale_root_url locale: :en

    @controller.request.stub(:hostname, "localhost") do
      assert_equal @controller.request.hostname, "localhost"
      assert_equal @controller.send(:production_server?), false
    end

    @controller.request.stub(:hostname, "www.example.com") do
      assert_equal @controller.request.hostname, "www.example.com"
      assert_equal @controller.send(:production_server?), true
    end
  end

  test "should add flash message" do
    get locale_root_url locale: :en

    result = @controller.send(:add_flash, :invalid_type, "There was a success")
    assert_nil @controller.flash[:invalid_type]
    assert_equal result, false

    @controller.send(:add_flash, :success, "There was a success")
    assert_equal @controller.flash[:success], ["There was a success"]

    @controller.send(:add_flash, :success, "There was a success")
    assert_equal @controller.flash[:success], ["There was a success", "There was a success"]

    @controller.send(:add_flash, :danger, "There was an error")
    assert_equal @controller.flash[:danger], ["There was an error"]

    @controller.send(:add_flash, :warning, "There was an error")
    assert_equal @controller.flash[:warning], ["There was an error"]

    @controller.send(:add_flash, :warning, ["There was an error"])
    assert_equal @controller.flash[:warning], ["There was an error", "There was an error"]

    @controller.flash[:warning] = nil
    @controller.send(:add_flash, :warning, [["There was an "],"error"])
    assert_equal @controller.flash[:warning], ["There was an error"]

    @controller.send(:add_flash, :warning, nil)
    assert_equal @controller.flash[:warning], ["There was an error"]

    @controller.send(:add_flash, :warning, "")
    assert_equal @controller.flash[:warning], ["There was an error"]

  end
end
