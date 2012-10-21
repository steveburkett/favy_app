class ItemsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item = Item.new
  end

  def create
    list = List.find(params[:item][:list_id])
    @item = Item.new(:name => params[:item][:name], :location => params[:item][:location], :category => params[:item][:category], :initial_comment => params[:item][:initial_comment])
    @item.list = list
    authorize! :create, @item
    respond_to do |format|
      if @item.save
        if params[:item][:category]
          @item.list.tag_list.push(params[:item][:category])
        end
        if params[:item][:location]
          @item.list.tag_list.push(params[:item][:location])
        end
        @item.list.save

        format.html
        format.json
        format.js {render :create}
      end
    end
  end

  def add
    list = current_user.lists.where("title = ?", params[:list]).first
    item = Item.find(params[:item_id])
    list.items.create(:name => item.name, :location => item.location, :category => item.category)
    
        if item.category
          list.tag_list.push(item.category)
        end
        if item.location
          list.tag_list.push(item.location)
        end
        list.save

    respond_to do |format|


        format.html
        format.json
        format.js {render :add}
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
    respond_to do |format|
      format.html {redirect_to user_path(current_user)}
      format.js
    end
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
