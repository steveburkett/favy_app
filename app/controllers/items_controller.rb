class ItemsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item = Item.new
  end

  def create
    list = List.find(params[:item][:list_id])
    @item = Item.new(:name => params[:item][:name])
    @item.list = list
    authorize! :create, @item
    respond_to do |format|
      if @item.save
        format.html
        format.json
        format.js {render :create}
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @item = Item.find(params[:id])
    authorize! :destroy, @item
    @item.destroy
    flash[:success] = "Item deleted."
    redirect_to user_path(current_user)
  end

  def index
  end

  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
