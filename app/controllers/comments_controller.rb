class CommentsController < ApplicationController
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
    @comment = comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted."
    redirect_to main_path
  end

  def index
  end

  def show
  end
end
