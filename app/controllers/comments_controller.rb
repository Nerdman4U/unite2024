class CommentsController < ApplicationController
  before_action :set_comment, only: [ :show, :edit ]

  def new
    unless session[:current_vote_id]
      redirect_to new_vote_path(locale: locale)
      return
    end

    vote = Vote.where(id: session[:current_vote_id]).first
    unless vote
      redirect_to new_vote_path(locale: locale)
      return
    end

    @vote = vote
    @comment = Comment.new
  end

  def create
    unless session[:current_vote_id]
      flash[:error] = _("You need to be logged in")
      redirect_to new_vote_path(locale: locale)
      return
    end

    vote = Vote.where(id: session[:current_vote_id]).first
    unless vote
      flash[:error] = _("There was an error")
      Rails.logger.error("Comment#create: Vote not found")
      redirect_to locale_root_path(locale: locale)
      return
    end

    unless RecaptchaVerifier.verify(params["g-recaptcha-response"])
      Rails.logger.error("Comment#create: Human verification failed")
      flash[:warning] = _("There was an error with human verifying")
      redirect_to new_comment_path(locale: locale)
      return
    end

    @comment = Comment.new(comment_params)
    @comment.ip = request.env["REMOTE_ADDR"]
    @comment.bypass_humanizer = true if Rails.env.test?
    @vote = vote
    @comment.vote = vote

    unless @comment.valid?
      Rails.logger.error("Comment#create: Invalid comment")
      flash[:warning] = validation_errors(@comment)
      Rails.logger.error(validation_errors(@comment))
      redirect_to new_comment_path(locale: locale)
      return
    end

    @comment.save
    @comment.email_comment

    respond_to do |format|
      format.html {
        flash[:success] = _("Your comment has been sent")
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
