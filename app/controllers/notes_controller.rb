class NotesController < ApplicationController
  before_action :set_group, except: [:show, :edit]
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
    # GET /notes
    # GET /notes.json
    def index
      @notes = @group.notes.all
    end
  
    #def delete_all
    #  Note.find_by_id(params[:format]).attachments.delete_all
    #  flash[:info] = "Documento eliminado"
    #  redirect_to groups_path
    #end

    # GET /notes/1
    # GET /notes/1.json
    def show
      @group= @note.group
    end
  
    # GET /notes/new
    def new
      @note = Note.new(group_id: @group.id, user_id: current_user.id )
    end
  
    # GET /notes/1/edit
    def edit
      @group= @note.group
    end
  
    # POST /notes
    # POST /notes.json
    def create
      @note = Note.new(note_params)
      if @note.save
        flash[:info] = "Nota creada exitosamente"
        redirect_to note_path(@note)
      else
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :new
      end
    end
  
    # PATCH/PUT /notes/1
    # PATCH/PUT /notes/1.json
    def update
      if @note.update(note_params)
        flash[:info] = "Nota editada exitosamente"
        redirect_to note_path(@note)
      else
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :edit
      end
    end
  
    # DELETE /notes/1
    # DELETE /notes/1.json
    def destroy
      if @note.destroy
        flash[:info] = "Nota eliminada exitosamente"
        redirect_to groups_path
      else 
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        redirect_to groups_path
      end
    end
  
    def savers
      @note  = Note.find(params[:id])
      @users = @event.savers.all
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_note
        @note = Note.find(params[:id])
      end
  
      def set_group
        if params[:id]
           @group = Group.find_by(id: params[:id])
        else
          @group = Group.find_by(id: params[:group_id])
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def note_params
        params.require(:note).permit(:name, :notespic, :tag_list, :body, :user_id, :group_id, attachments_attributes: [:attachment, :note_id])
      end

      def require_same_user
        if current_user != @note.user && !current_user.admin?
          flash[:info] = "Solo puedes editar o borrar tus propias notas"
          redirect_to groups_path
        end   
      end
  end