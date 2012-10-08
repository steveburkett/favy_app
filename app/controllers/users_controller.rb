class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  	@user = User.find(params[:id])
  	@lists = @user.lists.order(:title)
  end

  def index
  	@users = User.order(:lastname)
  end

  def friends
  	@user = User.find(params[:id])
  end
end
