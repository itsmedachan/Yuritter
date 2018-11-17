class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #log_inはsession helperで自分で定義したメソッド
      log_in user
      flash[:notice]="Welcome back to Yuritter!"
      redirect_to user
      #redirect_to user_url(user) #と等価
    else
      @error_message="Invalid login, please try again."
      render 'new'
    end
  end

  def destroy
    #log_outはsession helperで自分で定義したメソッド
    log_out
    flash[:notice]="Good-bye! I hope to see you again!"
    redirect_to login_url
    #redirectするときはpathじゃなくurlを使おう
  end

end
