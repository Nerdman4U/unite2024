# -*- coding: utf-8 -*-

require "test_helper"

class RouteTest < ActionDispatch::IntegrationTest

  ##########################################
  # Welcome
  ##########################################

  # TODO:
  # How to test a redirect from "/" to "/en"?
  #
  # test "should get index"  do
  #   assert_recognizes({controller: "welcome", action: "index", locale: "en"}, "/")
  # end

  test "should get index with locale" do
    Language::UI.locales.each do |locale|
      assert_routing "/#{locale}", controller: "welcome", action: "index", locale: locale
    end
  end

  test "should get route to vote path" do
    Language::UI.locales.each do |locale|
      assert_routing "/#{locale}/votes/my-token", controller: "votes", action: "show", locale: locale, token: "my-token"
    end
  end

  test "should route to material path" do
    assert_routing "/en/material", controller: "welcome", action: "material", locale: "en"
  end

  ##########################################
  # Votes
  ##########################################

  # TODO:
  # Should test a redirect from "/wrong_locale" to "/en".
  #
  # test "should redirect to index with wrong locale" do
  # end

  test "should route recently added votes path" do
    assert_routing "/votes/recently_added", controller: "votes", action: "recently_added"
  end

  test "should route add parent vote path" do
    assert_routing "/votes/add_parent", controller: "votes", action: "add_parent"
  end

  test "should route invite path" do
    assert_recognizes({controller: "votes", action: "invite"}, { path:"/votes/invite", method: :post })
  end

  test "should route waiting path" do
    assert_routing "/en/votes/waiting/my_token", controller: "votes", action: "waiting", locale: "en", token: "my_token"
  end

  test "should route confirm path" do
    assert_routing "/en/votes/confirm/my_token", controller: "votes", action: "confirm", locale: "en", token: "my_token"
    assert_routing "/en/votes/confirm/my-token", controller: "votes", action: "confirm", locale: "en", token: "my-token"
  end

  ##########################################
  # Tokens
  ##########################################

  test "should route new token path" do
    assert_routing "/en/token/new", controller: "tokens", action: "new", locale: "en"
  end

  test "should route delete token path" do
    assert_recognizes({controller: "tokens", action: "destroy"}, { path:"/tokens", method: :delete})
  end

  ##########################################
  # Comments
  ##########################################

  test "should route comments path" do
    assert_routing "/en/comments", controller: "comments", action: "index", locale: "en"
    assert_routing "/en/comments/new", controller: "comments", action: "new", locale: "en"
    assert_routing "/en/comments/123", controller: "comments", action: "show", id: "123", locale: "en"
    # TODO:
    # How to test a routing error?
    #
    # assert_raises(ActionController::RoutingError) do
    #   get "/en/comments/asdf"
    # end
    # assert_routing "/en/comments/asdf", controller: "comments", action: "show", id: "asdf", locale: "en"
    assert_recognizes({controller: "comments", action: "create"}, { path:"/comments", method: :post})

    assert_equal create_comment_path, "/comments"
  end

end
