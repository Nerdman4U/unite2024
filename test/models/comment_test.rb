require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
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
    Language.names.each do |name|
      @comment.language = name
      assert @comment.valid?, @comment.errors.full_messages
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

end
