class ApplicationController < ActionController::Base
  #CSRF対策
  protect_from_forgery with: :exception

  #どのcontrollerからでもsession用helperを使えるようにする
  include SessionsHelper


  before_action :set_current_user
  def set_current_user
    @current_user=User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if @current_user==nil
      flash[:notice]="You need to log in."
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice]="You have already logged in."
      redirect_to("/posts/index")
    end
  end

end
