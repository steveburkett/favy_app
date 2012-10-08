class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
  end

  def create
    item = Item.find(params[:comment][:item_id])
    @comment = Comment.new(:body => params[:comment][:body])
    @comment.item = item
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html
        format.json
        format.js
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted."
    redirect_to user_path(current_user)
  end

  def index
  end

  def show
  end
end
