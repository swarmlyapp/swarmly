class ClipsController < ApplicationController
  before_action :set_group, except: [:show, :edit]
  before_action :set_clip, except: [:index, :new, :create]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @clips = @group.clips.all
  end

  def new
    @clip = Clip.new(group_id: @group.id, user_id: current_user.id)
    @attachment = @clip.attachments.build
  end

  def create
    @clip = Clip.new(clip_params)
    if @clip.save
      if params[:attachments]
        params[:attachments].each do |attachment|
          @clip.attachments.create(attachment: attachment)
        end
      end
      create_notification("clip", @clip)
      flash[:info] = "Clip creado exitosamente"
      redirect_to clip_path(@clip)
    else      
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render :new
    end
  end

  def show    
    @group = @clip.group
  end

  def edit 
    @group = @clip.group
  end

  def update
    if @clip.update(clip_params)
      if params[:attachments]
        params[:attachments].each do |attachment|
          @clip.attachments.create(attachment: attachment)
        end
      end
        flash[:info] = "Clip editado exitosamente"
        redirect_to clip_path(@clip)
    else 
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render :edit
    end
  end

  def destroy
    if @clip.destroy
      flash[:info] = "Clip eliminado exitosamente"
      redirect_to groups_path
    else 
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render :show
    end
  end

  private
  def set_clip
    @clip = Clip.find_by(id: params[:id])
  end

  def set_group
    if params[:id]
       @group = Group.find_by(id: params[:id])
    else
      @group = Group.find_by(id: params[:group_id])
    end
  end

  def clip_params
    params.require(:clip).permit(:caption, :user_id, :group_id, attachments_attributes: [:attachment, :clip_id])
  end

  def require_same_user
    if current_user != @clip.user && !current_user.admin?
      flash[:info] = "Solo puedes editar o borrar tus clips"
      redirect_to groups_path
    end   
  end
end
