class RelationshipsController < ApplicationController

  before_action :authenticate_user

    def create
      user = User.find(params[:followed_id])
      #user.rbで定義したfollowメソッドが使える
      current_user.follow(user)
      redirect_to user
      # @relationship=Relationship.new(
      #   follower_id: @current_user.id,
      #   followed_id: params[:id]
      # )
      # @relationship.save
      flash[:notice]="Followed!"
      # redirect_to("/users/#{params[:id]}")
    end


    def destroy
      # user = Relationship.find(params[:id]).followed
      # current_user.unfollow(user)
      @relationship=Relationship.find_by(
         follower_id: @current_user.id,
         followed_id: params[:id]
      )
      @relationship.destroy
      redirect_to("/users/#{params[:id]}")
    end

#   private
#
#    def create_params
#        params.permit(:following_id).merge(follower_id: @current_user.id)
#    end
end
