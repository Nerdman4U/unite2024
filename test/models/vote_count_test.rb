require 'test_helper'

class VoteCountTest < ActiveSupport::TestCase

  def teardown
    VoteCount.destroy_all
    VoteCount.clear_values
  end

  test 'should add vote count' do
    vote = votes(:vote_1)
    VoteCount.add_vote(vote)
    vote_count = VoteCount.where(:country => "FI").first

    assert vote_count
    assert_equal vote_count.count, 1001
  end

  # TODO: fix. Base.deliveries seems to be sometimes empty and
  # sometimes not...
  #
  # test 'should send names after 100 new votes' do
  #   vote_count = VoteCount.where(:country => "FI").first
  #   vote_count.count = 99
  #   vote = votes(:vote_1)
  #   VoteCount.add_vote(vote)
  #   assert_not ActionMailer::Base.deliveries.empty?
  # end

  test 'should not add vote whene unvalid data' do
    assert_not VoteCount.new(:country => nil).save
    assert_not VoteCount.new(country: "fi", count: 0).save
    assert_not VoteCount.new(country: "fi", count: "a").save
    assert_not VoteCount.new(country: "fii", count: 1).save
  end

  test 'should add vote count with correct country name' do
    vote = VoteCount.new(:country => "FI", :count => 1)
    vote.save
    assert_equal vote.country, "fi"
  end

  test 'should return correct percent of all votes' do
    vote1 = vote_counts(:vote_count_fi)
    vote2 = vote_counts(:vote_count_gb)

    VoteCount.clear_values
    assert_equal VoteCount.total, 3000
    assert_equal vote1.percent_of_total.to_i, 33
    assert_equal vote2.percent_of_total.to_i, 66
  end

  test 'should return correct diagram width percent' do
    vote1 = vote_counts(:vote_count_fi)
    vote2 = vote_counts(:vote_count_gb)

    VoteCount.clear_values
    assert_equal VoteCount.total, 3000
    assert_equal vote1.diagram_width, 50
    assert_equal vote2.diagram_width, 100
  end

  test 'should calculate diagram width correctly' do
    assert_equal VoteCount.new.calculate_diagram_width(100000, 10000), 10
    assert_equal VoteCount.new.calculate_diagram_width(100000, 20000), 20
    assert_equal VoteCount.new.calculate_diagram_width(100000, 30000), 30
  end

end
