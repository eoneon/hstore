class SearchesController < ApplicationController
  def new
  @search = Search.new(item_type_id: params[:item_type_id])
  end

  def create
    @search = Search.new(search_params)

    if @search.save
      redirect_to @search
    else
      render :new
    end
  end

  def show
    @search = Search.find(params[:id])
  end

  private
  def search_params
    # params.require(:search).permit(:name, :item_type_id)
    properties = params[:search].delete(:properties)
    params.require(:search).permit(:item_type_id).tap do |whitelisted|
       whitelisted[:properties] = properties
     end
  end
end
