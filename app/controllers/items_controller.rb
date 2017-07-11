class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new(item_type_id: params[:item_type_id])
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      flash[:notice] = "Item was saved successfully."
      redirect_to @item
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
      redirect_to @item
    else
      flash.now[:alert] = "Error updated item. Please try again."
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.destroy
      flash[:notice] = "\"#{@item.sku}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the item."
      render :show
    end
  end

  private

  def item_params
    #unpermitted params = :name, :leg_count
    # params.require(:item).permit(:sku, :item_type_id, :properties => {})
    #syntax error, unexpected ',', expecting => ...type_id, :properties => {:name, :leg_count}) ... ^
    #params.require(:item).permit(:sku, :item_type_id, :properties => {:name, :leg_count})
    #https://stackoverflow.com/questions/19172893/rails-hashes-with-unknown-keys-and-strong-parameters
    properties = params[:item].delete(:properties)
    params.require(:item).permit(:name, :item_type_id).tap do |whitelisted|
       whitelisted[:properties] = properties
     end
  end
end
