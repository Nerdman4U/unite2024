require "test_helper"
class AdminControllerTest < ActionDispatch::IntegrationTest
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