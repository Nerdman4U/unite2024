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

  test "should localize" do
  end

  test 'should not get admin index with wrong hash' do
    get :admin, admin_hash: "foobar"
    assert_response :redirect
  end

  test 'should get admin page' do
    get :admin, admin_hash: Rails.application.config.admin_hash
    assert_response :success
  end

  test 'should parse CSV- file' do    
    admin_csv = fixture_file_upload('files/admin_csv','text/plain')
    assert_difference("Vote.count", 2) do
      post :admin_upload, admin_hash: Rails.application.config.admin_hash, admin_csv: admin_csv
    end
    assert_not ActionMailer::Base.deliveries.empty?    
  end

  test 'should not add votes if csv is nil' do
    admin_csv = nil
    assert_no_difference("Vote.count") do
      post :admin_upload, admin_hash: Rails.application.config.admin_hash, admin_csv: admin_csv
    end    
    # assert ActionMailer::Base.deliveries.empty?
  end
  
  test 'should filter csv data' do
    get :index
    admin_csv = fixture_file_upload('files/admin_csv','text/plain')
    require "csv"
    data = CSV.parse(admin_csv)
    
    filtered = @controller.send(:filter_csv, data)
    assert filtered
    assert_equal filtered.size, 2
  end
  
end
