class DashboardController < ApplicationController

  def main
  	@lists = current_user.lists
  end
  
end
