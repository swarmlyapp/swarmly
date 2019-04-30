class AttachmentsController < ApplicationController
    #def destroy
    #    @attachment = Attachment.find(params[:id])
    #    if @attachment.destroy
    #        flash[:info] = "Attachment was deleted successfully!"
    #        redirect_to groups_path
    #    else
    #        flash[:info] = "Something went wrong"
    #        redirect_to groups_path
    #    end
    #end

    def create
        @attachment = Note.find_by_id(params[:note_id]).attachments.new(attachment: params[:file])
        if @attachment.save!
          respond_to do |format|
            format.json{ render :json => @attachment }
          end
        end
      end
     
      private
        def attachment_params
          params.require(:attachment).permit(:attachment)
        end
  end