class ListsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @lists = current_user.lists
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(params[:list])
    @list.user = current_user

    respond_to do |format|
      if @list.save
        format.html
        format.json
        format.js
      end
    end
  end

  def destroy
    @list = current_user.lists.find(params[:id])
    @list.destroy
    flash[:success] = "List deleted."
    redirect_to user_path(current_user)
  end

  def edit
  end

  def update
  end

end
