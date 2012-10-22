class ListsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @lists = current_user.lists
  end

  def new
    @list = List.new
  end

  def create
    title = params[:list][:title]
    tag_list = title
    @list = List.new(user_id: params[:list][:user_id], 
      title: title, tag_list: tag_list, privacy: params[:list][:privacy], sort_by: "category")
    authorize! :create, @list
    respond_to do |format|
      if @list.save
        format.html {redirect_to user_path(current_user)}
        format.json
        format.js
      else
        format.html {redirect_to user_path(current_user)}
      end
    end
  end

  def create_popup
  end

  def destroy
    @list = List.find(params[:id])
    authorize! :destroy, @list
    if !@list.reserved
      @list.destroy
      flash[:success] = "List deleted."
    end
    redirect_to user_path(current_user)
  end

  def edit
  end

  def update
  end

  def show
  end

  def change_privacy
    list = List.find(params[:list_id])
    authorize! :change_privacy, list
    privacy = params[:privacy]
    list.update_attributes(privacy: privacy)
    flash[:notice] = "Privacy updated."
    redirect_to user_path(current_user)
  end

  def sort
    list = List.find(params[:id])
    list.sort_by = params[:sort_by]
    list.save
    redirect_to user_path(list.user)
  end


end
