class FavoritesController < ApplicationController
  before_action :require_user

  def index
    @user = current_user
  end

  def create
    group = Group.find(params[:group_id])
    @favorite = current_user.favorites.build(group: group)
    if @favorite.save      
      flash[:info] = "Grupo añadido a favoritos"
      redirect_to favorites_path
    else 
      flash[:info] = "Algo salio mal"
      redirect_to favorites_path
    end
  end

  def destroy
    group = Group.find(params[:group_id])
    @favorite = current_user.favorites.find(params[:id])
    if @favorite.destroy
      flash[:info] = "Grupo removido de tus favoritos"
      redirect_to favorites_path
    else 
      flash[:info] = "Algo salio mal, intentalo de nuevo"
      redirect_to favorites_path
    end
  end
end
