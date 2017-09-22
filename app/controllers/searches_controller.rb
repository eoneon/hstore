class SearchesController < ApplicationController
  def new
    @search = Search.new(item_type_id: params[:item_type_id], mounting_type_id: params[:mounting_type_id], certificate_type_id: params[:certificate_type_id], signature_type_id: params[:signature_type_id], substrate_type_id: params[:substrate_type_id])
  end

  def show
    @search = Search.find(params[:id])
  end

  def create
    @search = Search.new(search_params)

    if @search.save
      if params[:redirect_location] == ':edit'
        redirect_to edit_search_path(@search)
      else
        redirect_to @search
      end
    else
      flash.now[:alert] = "Error creating search. Please try again."
      render :new
    end
  end

  def edit
    @search = Search.find(params[:id])
  end

  def update
    @search = Search.find(params[:id])
    @search.assign_attributes(search_params)

    if @search.save
      if params[:redirect_location] == ':edit'
        redirect_to edit_search_path(@search)
      else
        redirect_to @search
      end
    else
      flash.now[:alert] = "Error updated search. Please try again."
    end
  end

  private
  def search_params
    # params.require(:search).permit(:name, :item_type_id)
    properties = params[:search].delete(:properties)
    params.require(:search).permit(:item_type_id, :mounting_type_id, :certificate_type_id, :signature_type_id, :substrate_type_id).tap do |whitelisted|
       whitelisted[:properties] = properties
     end
  end
end
