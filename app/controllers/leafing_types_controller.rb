class LeafingTypesController < ApplicationController
  def index
    @leafing_types = LeafingType.all
  end

  def show
    @leafing_type = LeafingType.find(params[:id])
  end

  def new
    @leafing_type = LeafingType.new
  end

  def edit
    @leafing_type = LeafingType.find(params[:id])
  end

  def create
    @leafing_type = LeafingType.new(leafing_type_params)

    if @leafing_type.save
      flash[:notice] = "Leafing type was saved successfully."
      redirect_to @leafing_type
    else
      flash.now[:alert] = "Error creating leafing type. Please try again."
      render :new
    end
  end

  def update
    @leafing_type = LeafingType.find(params[:id])
    @leafing_type.assign_attributes(leafing_type_params)

    if @leafing_type.save
      flash[:notice] = "Leafing type was updated successfully."
      redirect_to @leafing_type
    else
      flash.now[:alert] = "Error updated leafing type. Please try again."
      render :edit
    end
  end

  def destroy
    @leafing_type = LeafingType.find(params[:id])

    if @leafing_type.destroy
      flash[:notice] = "\"#{@leafing_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the leafing type."
      render :show
    end
  end

  private

  def leafing_type_params
    params.require(:leafing_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :leafing_type_id, :_destroy] })
  end
end
