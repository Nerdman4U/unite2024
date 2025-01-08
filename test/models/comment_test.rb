require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    I18n.locale = :en

    @comment = comments("one")
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

  test 'should validate language identifier' do
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

  test 'should make a slug' do
    assert @comment.slug
    assert @comment.slug.match(/water-testataan-kommentointia-\d+/), @comment.slug
    comment2 = comments("two")
    assert comment2.slug.match(/administration-no-testataan-vaan-lisää-tässä-yksi-kommentti!-\d+/), "comment2.slug: " + comment2.slug
  end

  test 'should have a slug after save' do
    @comment.slug = nil
    @comment.save
    assert @comment.slug.match(/water-testataan-kommentointia-\d+/), @comment.slug
  end

  test 'should find confirmed comments' do
    count1 = Comment.confirmed.count
    assert count1 > 0

    @comment.confirmed_at = nil
    @comment.save
    count2 = Comment.confirmed.count
    assert count2 < count1
  end

  test 'should give random comment for language' do
    assert Comment.random_comment_for_language('english').is_a? Comment
    assert_nil Comment.random_comment_for_language('arabic')
  end

end
