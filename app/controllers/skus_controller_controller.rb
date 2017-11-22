class SkusControllerController < ApplicationController
  def create
    @item = Item.find(params[:id])
    (@item.skus).each do |sku|
      new_item = item.dup
      new_item.update(sku: sku, title: "", artist_ids: item.artist_ids)
      new_item.save
    end
    redirect_to @item.invoice
  end

  private

  def item_params
    #https://stackoverflow.com/questions/19172893/rails-hashes-with-unknown-keys-and-strong-parameters
    properties = params[:item].delete(:properties)
    artists = params[:item].delete(:artist_ids)
    params.require(:item).permit(:sku_range, :title, :retail, :sku, :image_width, :image_height, :invoice_id, :item_type_id, :dimension_type_id, :edition_type_id, :certificate_type_id, :signature_type_id, :substrate_type_id, { :titles_attributes => [:id, :title] } ).tap do |whitelisted| #{ :artist_items_attributes => [:id, :artist_id, :item_id] }
       whitelisted[:properties] = properties
       whitelisted[:artist_ids] = artists
     end
  end
end
