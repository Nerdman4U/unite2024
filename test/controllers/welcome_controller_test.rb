# -*- coding: utf-8 -*-

require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  def teardown
    # Clear all unsend invitation mails
    ActionMailer::Base.deliveries.clear
  end

  test "should get index" do
    get root_path
    assert_response :success

    get locale_root_path
    assert_response :success
  end

  test "should not be logged in" do
    get root_path
    assert_select ".navigation .logout", :count == 0
  end

  test "should be logged in" do
    vote = votes("vote_1")
    get vote_path(token: vote.encoded_payload)
    assert_response :success
    assert_select ".navigation .logout"
    assert_select ".navigation .logout" do |a|
      assert_equal a.text, _("Logout")
    end
  end

  test "should get index with default locale" do
    get root_path
    assert_equal I18n.locale, :en
  end

  test "should have correct title" do
    get root_path
    assert_select "title", "Home (Save the Planet - Unite the Armies)"
  end

  test "should not get admin index with wrong hash" do
    get admin_index_url admin_hash: "foobar"
    assert_response :redirect
  end

  test "should get admin page" do
    get admin_index_url admin_hash: Rails.application.config.x.admin_hash
    assert_response :success
  end

  # TODO?
  # test "should parse CSV- file" do
  #   admin_csv = fixture_file_upload("admin_csv", "text/plain")
  #   assert_difference("Vote.count", 2) do
  #     post admin_upload_url(admin_hash: Rails.application.config.x.admin_hash, admin_csv: admin_csv)
  #   end

  #   # TODO
  #   # assert_not ActionMailer::Base.deliveries.empty?
  # end

  test "should not add votes if csv is nil" do
    admin_csv = nil
    assert_no_difference("Vote.count") do
      post admin_upload_url(admin_hash: Rails.application.config.x.admin_hash, admin_csv: admin_csv)
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
