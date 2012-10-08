class ListshipsController < ApplicationController
  before_filter :authenticate_user!
	
  def create
    @listship = current_user.listships.build(:followlist_id => params[:id])
    if @listship.save
      flash[:notice] = "List followed."
      list = List.find(params[:id])
      redirect_to user_path(id: list.user_id)
    else
      flash[:error] = "Unable to follow list."
      redirect_to root_path
    end  	
  end

  def destroy
  	Listship.where("user_id = ? and followlist_id = ?", current_user.id, params[:id]).first.destroy
    list = List.find(params[:id])
    redirect_to user_path(id: list.user_id)
  end

  def show
  end

  def index
  end
end
