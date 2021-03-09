class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @group  = Group.find(params[:group_id])
    @comment = @group.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      ActionCable.server.broadcast "comments", render(partial: "comments/comment", object: @comment)
      create_notification("comment", @comment)
    else
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      #redirect_to :back
      redirect_back
    end
  end
  
  private

  def comment_params
    params.require(:comment).permit(:description)  
  end
  
end