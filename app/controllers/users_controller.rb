class UsersController < ApplicationController

  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users=User.all.order(created_at: :desc)
  end

  def show
    @user=User.find_by(id: params[:id])
    @posts_count=Post.where(user_id: @user.id).count
    @likes_count=Like.where(user_id: @user.id).count
    @following_count=@user.following.count
    @followers_count=@user.followers.count
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(
      name: params[:name],
      email: params[:email],
      image_name: "kari_icon.jpg",
      password: params[:password])
    if @user.save
      session[:user_id]=@user.id
      flash[:notice]="Welcome to Yuritter!"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end

  def edit
    @user=User.find_by(id: params[:id])
  end

  def update
    @user=User.find_by(id: params[:id])
    @user.name=params[:name]
    @user.email=params[:email]
    if params[:image]
      @user.image_name="#{@user.id}.jpg"
      image=params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    if @user.save
      flash[:notice]="edited!"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def login_form
    #@user=User.find_by(email: params[:email], password: params[:password])
  end

  def login
    @user=User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      flash[:notice]="login successfully"
      redirect_to("/posts/index")
    else
      @error_message="Invalid login, please try again."
      @email=params[:email]
      @password=params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id]=nil
    flash[:notice]="logout successfully"
    redirect_to("/login")
  end

  def likes
    @user=User.find_by(id: params[:id])
    @likes=Like.where(user_id: @user.id)
    @posts_count=Post.where(user_id: @user.id).count
    @likes_count=Like.where(user_id: @user.id).count
    @following_count=@user.following.count
    @followers_count=@user.followers.count
  end

  def following
    @user=User.find(params[:id])
    @users=@user.following
    @posts_count=Post.where(user_id: @user.id).count
    @likes_count=Like.where(user_id: @user.id).count
    @following_count=@user.following.count
    @followers_count=@user.followers.count
  end

  def followers
    @user=User.find(params[:id])
    @users=@user.followers
    @posts_count=Post.where(user_id: @user.id).count
    @likes_count=Like.where(user_id: @user.id).count
    @following_count=@user.following.count
    @followers_count=@user.followers.count
  end



  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice]="You don't have permisson to access."
      redirect_to("/posts/index")
    end
  end


end
