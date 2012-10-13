class ListsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @lists = current_user.lists
  end

  def new
    @list = List.new
  end

  def create
    tag_list = params[:list][:tag_list]
    title = params[:list][:title]
    tag_list = tag_list + ", " + title
    @list = List.new(user_id: params[:list][:user_id], title: title, tag_list: tag_list, privacy: params[:list][:privacy])
    authorize! :create, @list
    respond_to do |format|
      if @list.save
        format.html
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
    @list.destroy
    flash[:success] = "List deleted."
    redirect_to user_path(current_user)
  end

  def edit
  end

  def update
  end

  def show
  end

  def change_privacy
    list = List.find(params[:id])
    authorize! :change_privacy, list
    privacy = params[:privacy]
    list.update_attributes(privacy: privacy)
    redirect_to user_path(current_user)
  end

end
