class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @feed_items = current_user.feed.all
    end
  end

  def conduct
    redirect_to 'https://www.swarmly.app/notes/14' 
  end

  def assetlinks
    respond_to do |format|
      format.json 
      render :partial => "static_pages/assetlinks.json"
    end
  end

  def lock
  end
  
  def explore
    @groups = Group.order(created_at: :desc).last(2)
    @categories = Category.order(created_at: :desc).last(3)
    @tags = Tag.order(created_at: :desc).last(5)
  end

  def login
    if logged_in?
      flash[:info] = "Ya estás dentro de la app"
      redirect_to root_path
    end
  end
  # private
  #   def set_category
  #      @category = Category.find(params[:id]) 
  #   end
end