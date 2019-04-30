class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :show] 
  before_action :require_admin, except: [:show, :index] 
  
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end
  
  def edit
  end 
  
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:info] = "Categoría creada exitosamente"
      redirect_to @category
    else
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render "new"
    end
  end
  
  def update
    if @category.update(category_params)
      flash[:info] = "Categoría editada exitosamente"
      redirect_to @category
    else
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      render "edit"
    end
  end
  
  def show
    @category_groups = @category.groups.all
  end
  
  private
    def set_category
       @category = Category.find(params[:id]) 
    end
    
    def category_params
      params.require(:category).permit(:name, :categoriespic)
    end
    
    def require_admin
      if !logged_in? ||(logged_in? && !current_user.admin?)
        flash[:info] = "Solo administradores pueden hacerlo"
        redirect_to categories_path
      end      
    end
  
end