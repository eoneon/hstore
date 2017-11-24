class ItemsController < ApplicationController
  def index
    @items = Item.all
    respond_to do |format|
      format.html
      format.csv { send_data @items.to_csv }
      format.xls { send_data @items.to_csv(col_sep: "\t") }
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @invoice = Invoice.find(params[:invoice_id])
    @item = Item.new(
      item_type_id: params[:item_type_id],
      dimension_type_id: params[:dimension_type_id],
      edition_type_id: params[:edition_type_id],
      certificate_type_id: params[:certificate_type_id],
      signature_type_id: params[:signature_type_id],
      substrate_type_id: params[:substrate_type_id])
  end

  def create
    @invoice = Invoice.find(params[:invoice_id])
    @item = @invoice.items.build(item_params)
    @new_item = Item.new

    if @item.save

      flash[:notice] = "Item was saved successfully."
      if params[:redirect_location] == ':edit'
        render :edit
      else
        redirect_to @item.invoice
      end
    else
      flash.now[:alert] = "Error creating item. Please try again."
      render :edit
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)

    if @item.save
      # flash[:notice] = "Item was updated successfully."
    else
      flash.now[:alert] = "Error updated item. Please try again."
    end
    redirect_to edit_invoice_item_path(@item.invoice, @item)
  end

  def destroy
    @invoice = Invoice.find(params[:invoice_id])
    @item = @invoice.items.find(params[:id])

    if @item.destroy
      flash[:notice] = "Item was deleted successfully."
    else
      flash.now[:alert] = "There was an error deleting the item."
    end
    redirect_to @item.invoice
  end

  def import
    Item.import(params[:file])
    redirect_to items_path
    flash[:notice] = "Items successfully imported."
  end

  def create_skus
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
    params.require(:item).permit(:sku_range, :title, :retail, :sku, :first_name, :last_name, :image_width, :image_height, :invoice_id, :item_type_id, :dimension_type_id, :edition_type_id, :certificate_type_id, :signature_type_id, :substrate_type_id, { :titles_attributes => [:id, :title] } ).tap do |whitelisted| #{ :artist_items_attributes => [:id, :artist_id, :item_id] }
       whitelisted[:properties] = properties
       whitelisted[:artist_ids] = artists
     end
    # params.require(:item).permit(:name, :item_type_id, :artist_id).tap do |whitelisted|
    #   whitelisted[:properties] = params[:item][:properties]
    # end
  end
end
