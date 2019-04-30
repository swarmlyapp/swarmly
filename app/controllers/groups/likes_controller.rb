class Groups::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def create
    @group.likes.where(user_id: current_user.id).first_or_create

    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  def destroy
    @group.likes.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  private

    def set_group
      @group = Group.find(params[:group_id])
    end
end