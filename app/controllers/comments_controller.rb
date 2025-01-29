class CommentsController < ApplicationController
  before_action :set_comment, only: [ :show, :edit ]

  def new
    unless logged_in?
      Rails.logger.warn("Comment#new: Not logged in")
      redirect_to new_vote_path(locale: locale)
      return
    end

    @slider = Slider.new({
      name: "comment",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "tehdas",
        headers: {
          h1: [_("Leave a comment")],
          h2: [_("Make an initiative for the action of the United Armies.")]
        },
        res: [640,960,1024,1280,1920,2048],
        type: 'jpg',
        default: 1024,
        alt: _("Factory"),
        decorators: ["headers", "image"]
      }]
    })

    unless vote = current_vote
      Rails.logger.error("Comment#new: Vote not found")
      redirect_to new_vote_path(locale: locale)
      return
    end

    @vote = vote
    @comment = Comment.new
  end

  def create
    unless logged_in?
      add_flash :danger, _("You need to be logged in")
      redirect_to new_vote_path(locale: locale)
      return
    end

    unless vote = current_vote
      add_flash :danger, _("There was an error")
      Rails.logger.error("Comment#create: Vote not found")
      redirect_to locale_root_path(locale: locale)
      return
    end

    unless RecaptchaVerifier.verify(params["g-recaptcha-response"])
      Rails.logger.error("Comment#create: Human verification failed")
      add_flash :warning, _("There was an error with human verifying")
      redirect_to new_comment_path(locale: locale)
      return
    end

    @comment = Comment.new(comment_params)
    @comment.ip = request.env["REMOTE_ADDR"]
    @vote = vote
    @comment.vote = vote

    unless @comment.valid?
      Rails.logger.error("Comment#create: Invalid comment")
      add_flash :warning, validation_errors(@comment)
      Rails.logger.error(validation_errors(@comment))
      redirect_to new_comment_path(locale: locale)
      return
    end

    @comment.save
    @comment.email_comment

    respond_to do |format|
      format.html {
        add_flash :success, _("Your comment has been sent")
        redirect_to vote_path(locale: locale, token: vote.encoded_payload), notice: _("Comment was successfully created.")
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:language, :theme, :body, :anonymous)
    end
end
