class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new(item_type_id: params[:item_type_id], mounting_type_id: params[:mounting_type_id], certificate_type_id: params[:certificate_type_id], signature_type_id: params[:signature_type_id], substrate_type_id: params[:substrate_type_id])
  end

  def create
    @item = Item.new(item_params)

    if @item.save

      flash[:notice] = "Item was saved successfully."
      if params[:redirect_location] == ':edit'
        render :edit
      else
        redirect_to @item
      end
    else
      flash.now[:alert] = "Error creating item. Please try again."
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)

    if @item.save
      flash[:notice] = "Item was updated successfully."
      if params[:redirect_location] == ':edit'
        render :edit
      else
        redirect_to @item
      end
    else
      flash.now[:alert] = "Error updated item. Please try again."
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.destroy
      flash[:notice] = "\"#{@item.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the item."
      render :index
    end
  end

  private

  def item_params
    #https://stackoverflow.com/questions/19172893/rails-hashes-with-unknown-keys-and-strong-parameters
    properties = params[:item].delete(:properties)
    artists = params[:item].delete(:artist_ids)
    titles = params[:item].delete(:title_ids)
    params.require(:item).permit(:name, :image_width, :image_height, :item_type_id, :mounting_type_id, :certificate_type_id, :signature_type_id, :substrate_type_id ).tap do |whitelisted| #{ :artist_items_attributes => [:id, :artist_id, :item_id] }
       whitelisted[:properties] = properties
       whitelisted[:artist_ids] = artists
       whitelisted[:title_ids] = titles
     end
    # params.require(:item).permit(:name, :item_type_id, :artist_id).tap do |whitelisted|
    #   whitelisted[:properties] = params[:item][:properties]
    # end
  end
end
