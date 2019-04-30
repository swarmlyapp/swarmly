class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end
  
  def show
    @comments = @group.comments.all
    @comment = Comment.new
  end
  
  def new
    @group = Group.new()
  end
  
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      flash[:info] = "Grupo creado exitosamente"
      redirect_to group_path(@group)
    else
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render "new"
    end
  end
  
  def edit
        
  end
   
  def update
   if @group.update(group_params)
     flash[:info] = "Grupo editado exitosamente"
     redirect_to group_path(@group)
   else
     flash[:info] = "Algo salio mal, intentalo de nuevo"
     render "edit"
   end
  end
  
  def destroy 
    if @group.destroy
      flash[:info] = "Grupo eliminado exitosamente"
      redirect_to groups_path
    else 
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render :show 
    end
  end
  
  private 
   def group_params
     params.require(:group).permit(:name, :groupspic, category_ids: [])
   end
   
   def set_group
     @group = Group.find(params[:id])
   end
   
   def require_same_user
     if current_user != @group.user && !current_user.admin?
       flash[:info] = "Solo puedes editar o borrar tus grupos"
       redirect_to groups_path
     end   
   end
end