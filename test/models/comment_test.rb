require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    I18n.locale = :en

    @comment = comments("one")
    @comment.bypass_humanizer = true
    @comment.vote = votes("vote_1")
  end

  test "should be valid with default data" do
    assert @comment.valid?, @comment.errors.full_messages
  end

  test "should not be valid without an ip" do
    @comment.ip = ""
    assert_not @comment.valid?
  end

  test "should not be valid without a language" do
    @comment.language = ""
    assert_not @comment.valid?
  end

  test "should not be valid with wrong language" do
    @comment.language = "English"
    assert_not @comment.valid?, @comment.errors.full_messages

    @comment.language = "englis"
    assert_not @comment.valid?, @comment.errors.full_messages
  end

  test "should be valid with correct language" do
    Language::UN.identifiers.each do |identifier|
      @comment.language = identifier
      assert @comment.valid?
    end
  end

  test "should not be valid without correct theme" do
    @comment.theme = ""
    assert_not @comment.valid?
    @comment.theme = "foo"
    assert_not @comment.valid?
  end

  test "should be valid with correct theme" do
    themes = %w(administration water climate plastic-waste protected-areas)
    themes.each do |theme|
      @comment.theme = theme
      assert @comment.valid?, @comment.errors.full_messages
    end
  end

  test 'should not save without a vote' do
    @comment.vote = nil
    assert_not @comment.valid?
  end

  test 'should validate language literal' do
    @comment.language = 'foo'
    assert_not @comment.valid?

    @comment.language = nil
    assert_not @comment.valid?
  end

  test 'should return language name' do
    @comment.language = 'english'
    assert_equal 'English', @comment.language_name

    @comment.language = nil
    assert_nil @comment.language_name
  end

  test 'should validate theme' do
    @comment.theme = 'foo'
    assert_not @comment.valid?
    assert @comment.errors[:theme].present?
    assert @comment.errors[:theme].include? "is not valid"

    @comment.theme = nil
    assert_not @comment.valid?
    assert @comment.errors[:theme].present?
    assert @comment.errors[:theme].include? "You need to select a theme before posting a comment."

    @comment.theme = 'climate'
    assert @comment.valid?
  end


end
