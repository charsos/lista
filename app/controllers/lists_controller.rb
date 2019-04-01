class ListsController < ApplicationController
  before_action :find_list, only: [:show, :edit, :update, :destroy]
  def index
    @lists = List.all
  end

  def show
    @places = @list.places.where.not(latitude: nil, longitude: nil)

    @markers = @places.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude
      }
    end
  end

  def new
    @list = List.new # (list_params)
    @list.list_places.build.build_place
    # @list.places.build
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    # authorize @list
    # raise
    if @list.save
      # raise
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def update
    puts "THIS WAS A PATCH REQUEST"
  end

  def edit
  end

  def destroy
    @list.destroy
    redirect_to lists_path
  end

  private

  def find_list
    @list = List.find(params[:id])
    # authorize @list
  end

  def list_params
    params.require(:list).permit(:name, :description, :is_public, :photo, list_places_attributes: [:comments, place_attributes: [:name, :address, :photo, :latitude, :longitude]]) # , places_attributes: [:places, :name, :address])
  end
end
