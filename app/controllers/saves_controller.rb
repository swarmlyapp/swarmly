class SavesController < ApplicationController

  def index
    @notes = current_user.saving.all
  end

  def create
    @note = Note.find(params[:saved_note_id])
    current_user.saved(@note)
    respond_to do |format|
      format.html { redirect_to @note }
      format.js
    end
  end

  def destroy
    @note = Save.find(params[:id]).saved_note
    current_user.unsaved(@note)
    respond_to do |format|
      format.html { redirect_to @note }
      format.js
    end
  end
end
