class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.order(:last_name)
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    @artist = Artist.new
    @artist.displays.build
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      flash[:notice] = "Artist was saved successfully."
      redirect_to @artist
    else
      flash.now[:alert] = "Error creating Artist. Please try again."
      render :new
    end
  end

  def edit
    @artist = Artist.find(params[:id])
    @artist.displays.build
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.assign_attributes(artist_params)

    if @artist.save
      flash[:notice] = "Artist was updated successfully."
      redirect_to @artist
    else
      flash.now[:alert] = "Error updated Artist. Please try again."
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])

    if @artist.destroy
      flash[:notice] = "\"#{@artist.sku}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the Artist."
      render :show
    end
  end

  private

  def artist_params
    params.require(:artist).permit(:id, :first_name, :last_name, displays_attributes: [:id, :name, :artist_id])
  end
end
