class ListsController < ApplicationController
  def index
    @lists = current_user.lists
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(params[:list])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def delete
    @list = List.find(params[:id])
    @list.destroy
    flash[:success] = "List deleted."
    redirect_to lists_path
  end

  def edit
  end

  def update
  end

end
