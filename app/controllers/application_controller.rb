class ApplicationController < ActionController::Base
  protect_from_forgery

  private

      def after_sign_out_path_for(user)
        root_path
      end

      def after_sign_in_path_for(user)
		    user_path(user)
	    end

      def after_update_path_for(user)
        user_path(user)
      end

end
