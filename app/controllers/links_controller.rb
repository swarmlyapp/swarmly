class LinksController < ApplicationController
    before_action :set_group, except: [:show, :edit]
    before_action :set_link, except: [:index, :new, :create]
    before_action :require_user
    before_action :require_same_user, only: [:edit, :update, :destroy]
  
    def index
      @links = @group.links.all
    end
  
    def new
      @link = Link.new(group_id: @group.id, user_id: current_user.id)
    end
  
    def create
      @link = Link.new(link_params)
      if @link.save
        create_notification("link", @link)
        flash[:info] = "Link creado exitosamente"
        redirect :back
      else      
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :new
      end
    end
  
    def edit 
      @group = @link.group
    end
  
    def update
      if @link.update(link_params)
        flash[:info] = "Link editado exitosamente"
        redirect_to link_path(@link)
      else 
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :edit
      end
    end
  
    def destroy
      if @link.destroy
        flash[:info] = "Link eliminado exitosamente"
        redirect_to groups_path
      else 
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :show
      end
    end
  
    private
    def set_link
      @link = Link.find_by(id: params[:id])
    end
  
    def set_group
      if params[:id]
         @group = Group.find_by(id: params[:id])
      else
        @group = Group.find_by(id: params[:group_id])
      end
    end
  
    def link_params
      params.require(:link).permit(:title, :url, :content, :user_id, :group_id)
    end
  
    def require_same_user
      if current_user != @link.user && !current_user.admin?
        flash[:info] = "Solo puedes editar o borrar tus links"
        redirect_to groups_path
      end   
    end
  end
