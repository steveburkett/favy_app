class ItemsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def new
    @item = Item.new
  end

  def create
    list = List.find(params[:item][:list_id])
    @item = Item.new(:name => params[:item][:name], :initial_comment => params[:item][:initial_comment])
    @item.list = list
    @item.location_name = params[:item][:location_name]
    @item.category_name = params[:item][:category_name]

    authorize! :create, @item
    respond_to do |format|
      if @item.save
        if !params[:item][:category_name].blank?
          list.tag_list.push(params[:item][:category_name])
        end
        if !params[:item][:location_name].blank?
          list.tag_list.push(params[:item][:location_name])
        end
        list.save

        format.html
        format.json
        format.js {render :create}
      end
    end
  end

  def add
    list = current_user.lists.where("title = ?", params[:list]).first
    item = Item.find(params[:item_id])
    item_copy = Item.new(:name => item.name, :initial_comment => params[:initial_comment])
    item_copy.list = list
    item_copy.location_name = item.location_name
    item_copy.category_name = item.category_name
    item_copy.save

        if item_copy.category
          list.tag_list.push(item_copy.category_name)
        end
        if item_copy.location
          list.tag_list.push(item_copy.location_name)
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




    #@locations = Location.order(:name).where("name like ?", "%#{params[:term]}%")
    #render json: @locations.map(&:name)
    #@items = [Item.new(name:"test1"), Item.new(name:"test2")]
    render json: ["item1","item2"]#@items.map(&:name)



  end

  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
