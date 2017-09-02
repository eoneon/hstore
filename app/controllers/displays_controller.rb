class DisplaysController < ApplicationController
  def create
    @artist = Artist.find(params[:artist_id])
    @display = @artist.items.build(display_params)
    @new_display = Display.new

    if @display.save
      flash[:notice] = "Display name was saved successfully."
    else
      flash[:alert] = "Error updating display name. Please try again."
    end
  end

  def update
    @display = Artist.find(params[:id])
    @display.assign_attributes(display_params)

    if @display.save
      flash[:notice] = "Item was updated successfully."
    else
      flash.now[:alert] = "Error updated item. Please try again."
    end
  end

  def destroy
    @display = Item.find(params[:id])

    if @display.destroy
      flash[:notice] = "\"#{@display.name}\" was deleted successfully."
    else
      flash.now[:alert] = "There was an error deleting the item."
    end

    render :edit
  end

  private

  def display_params
    params.require(:display).permit(:name)
  end
end
