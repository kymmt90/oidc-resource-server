class SessionsController < ApplicationController
  def new
    @user = current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      signin(user)
    end

    redirect_to new_session_path
  end

  def destroy
    signout(current_user) if current_user

    redirect_to new_session_path
  end

  private

  def signin(user)
    reset_session
    session[:current_user_id] = user.id
  end

  def signout(user)
    reset_session
    @current_user = nil
  end
end
