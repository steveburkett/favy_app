class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    puts request.env["omniauth.auth"]
    session['fb_access_token'] = request.env["omniauth.auth"]['credentials']['token']

    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      @user.remember_me!
      @user.create_facebook_friendships
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "Email already taken or error logging in"
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_session_path
    end
  end
end