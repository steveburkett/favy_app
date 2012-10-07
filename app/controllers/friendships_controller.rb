class FriendshipsController < ApplicationController
  def index
  end

  def create
    puts params[:friend_id]
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], :approved => false)
    if @friendship.save
      flash[:notice] = "Request sent."
      redirect_to root_path
    else
      flash[:error] = "Unable to send request."
      redirect_to root_path
    end
  end

  def approve
  end

  def ignore
  end

  def delete
  end
end
