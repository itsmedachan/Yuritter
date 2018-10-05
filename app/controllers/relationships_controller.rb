class RelationshipsController < ApplicationController

  before_action :authenticate_user

    def create
      @relationship=Relationship.new(
        follower_id: @current_user.id,
        following_id: params[:id]
      )
      @relationship.save
      flash[:notice]="Followed!"
      redirect_to("/users/#{params[:id]}")
    end


    def destroy
      @relationship=Relationship.find_by(
        follower_id: @current_user.id,
        following_id: params[:id]
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
