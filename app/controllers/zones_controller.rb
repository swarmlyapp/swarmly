class ZonesController < ApplicationController
    before_action :set_group, except: [:show, :edit]    
    before_action :set_zone, only: [:show, :edit, :update, :destroy]
    before_action :require_user
    before_action :require_same_user, only: [:edit, :update, :destroy]  
    
    def index
      @zones = @group.zones.where.not(latitude: nil, longitude: nil)
  
      @hash = Gmaps4rails.build_markers(@zones) do |zone, marker|
        marker.lat zone.latitude
        marker.lng zone.longitude
        marker.infowindow render_to_string(partial: "/zones/map_box", locals: { zone: zone })
        marker.picture({
          "url": "https://res.cloudinary.com/swarmly/image/upload/v1548062475/swarmlymarker.png",
          "width":  45,
          "height": 66})
      end
    end

    def show
      @group = @zone.group
    end
  
    def new
      @zone = Zone.new(group_id: @group.id, user_id: current_user.id)
    end
  
    def edit
      @group = @zone.group
    end
  
    def create
      @zone = Zone.new(zone_params)
      if @zone.save
        create_notification("zone", @zone)
        flash[:info] = "Zona Swarmly creada"
        redirect_to zone_path(@zone)
      else      
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :new
      end
    end
  
    def update
      if @zone.update(zone_params)
        flash[:info] = "Zona Swarmly editada"
        redirect_to zone_path(@zone)
      else 
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :edit
      end
    end
  
    def destroy
      if @zone.destroy
        flash[:info] = "Zona Swarmly eliminada"
        redirect_to groups_path
      else 
        flash[:info] = "Algo salio mal, intentalo de nuevo"
        render :show
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_zone
        @zone = Zone.find(params[:id])
      end

      def set_group
        if params[:id]
           @group = Group.find_by(id: params[:id])
        else
          @group = Group.find_by(id: params[:group_id])
        end
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def zone_params
        params.require(:zone).permit(:name, :zonespic, :day, :hour, :price, :user_id, :group_id, :address)
      end

      def require_same_user
        if current_user != @zone.user && !current_user.admin?
          flash[:info] = "Solo puedes editar o borrar tus Zonas"
          redirect_to groups_path
        end   
      end
 end
  