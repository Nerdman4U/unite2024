class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit]

  # GET /comments
  # GET /comments.json
  # def index
  #  @comments = Comment.all
  #  render layout: "simple_layout"
  # end

  # GET /comments/1
  # GET /comments/1.json
  # def show
  # end

  # GET /comments/new
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

  # GET /comments/1/edit
  # def edit
  # end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.ip = request.env["REMOTE_ADDR"]
    @comment.bypass_humanizer = true if Rails.env.test?

    unless session[:current_vote_id]
      redirect_to new_vote_path(locale: locale)
      return
    end

    unless RecaptchaVerifier.verify(params["g-recaptcha-response"])
      redirect_to new_vote_path(locale: locale)
      return
    end

    vote = Vote.where(id: session[:current_vote_id]).first
    unless vote
      redirect_to new_vote_path(locale: locale)
      return
    end

    @vote = vote
    @comment.vote = vote

    respond_to do |format|
      if @comment.save
        @comment.email_comment
        msg = _("Comment was successfully created.")
        values = {
          locale: locale,
          secret_token: vote.secret_token
        }
        format.html { redirect_to vote_path(values), notice: msg }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  # def update
  #   respond_to do |format|
  #     if @comment.update(comment_params)
  #       format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @comment }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @comment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /comments/1
  # DELETE /comments/1.json
  # def destroy
  #   @comment.destroy
  #   respond_to do |format|
  #     format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:topic, :body, :email, :email_confirmation, :theme, :language, :name, :humanizer_answer, :humanizer_question_id)
    end
end
