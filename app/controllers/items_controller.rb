class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    list = List.find(params[:item][:list_id])
    @item = Item.new(:name => params[:item][:name])
    @item.list = list
    respond_to do |format|
      if @item.save
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

  def delete
    @item = Item.find(params[:id])
    @item.destroy
    flash[:success] = "Item deleted."
    redirect_to main_path
  end

  def index
  end

  def show
  end
end
