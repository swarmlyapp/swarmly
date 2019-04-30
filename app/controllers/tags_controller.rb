class TagsController < ApplicationController
	
	def index
		@tags = Tag.all
	end
	
	def show
		@tag = Tag.find(params[:id])
		@tag_notes = @tag.notes
	end

	def destroy
		@tag = Tag.find(params[:id])
		@tag.destroy
		flash[:info] = "Tag '#{@tag.name}' eliminado"
		redirect_to tags_path
	end
end