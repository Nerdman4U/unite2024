# -*- coding: utf-8 -*-
require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  def teardown
    # Clear all unsend invitation mails
    ActionMailer::Base.deliveries.clear
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index with default locale" do
    get :index
    assert @controller.locale == :en, "Wrong default locale, locale: #{@controller.locale}."
  end

  test "should have correct title" do
    session[:locale] = :en
    get :index
    assert_select "title", "Save the Planet - Unite the Armies!"
  end

  # test "should localize" do
  # end

  test 'should not get admin index with wrong hash' do
    get :admin, params: { admin_hash: "foobar" }
    assert_response :redirect
  end

  test 'should get admin page' do
    get :admin, params: { admin_hash: Rails.application.config.admin_hash }
    assert_response :success
  end

  test 'should parse CSV- file' do
    admin_csv = fixture_file_upload('admin_csv','text/plain')
    assert_difference("Vote.count", 2) do
      post :admin_upload, params: { admin_hash: Rails.application.config.admin_hash, admin_csv: admin_csv }
    end

    # TODO
    # assert_not ActionMailer::Base.deliveries.empty?
  end

  test 'should not add votes if csv is nil' do
    admin_csv = nil
    assert_no_difference("Vote.count") do
      post :admin_upload, params: { admin_hash: Rails.application.config.admin_hash, admin_csv: admin_csv }
    end
    # assert ActionMailer::Base.deliveries.empty?
  end

  # test 'should filter csv data' do
  #   get :index
  #   admin_csv = fixture_file_upload('admin_csv','text/plain')
  #   require "csv"
  #   data = CSV.parse(admin_csv)

  #   # TODO
  #   # @controller.send does not return anything but it
  #   # seems to work
  #   filtered = @controller.send(:filter_csv, params: data)
  #   # puts "final: #{filtered.inspect}"
  #   #assert filtered
  #   #assert_equal filtered.size, 2
  # end

end
