class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @category = Category.find(params[:followed_id])
    current_user.follow(@category)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category = Relationship.find(params[:id]).followed
    current_user.unfollow(@category)
    respond_to do |format|
      format.js
    end
  end
end
