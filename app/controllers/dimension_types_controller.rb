class DimensionTypesController < ApplicationController
  def index
    @dimension_types = DimensionType.all
  end

  def show
    @dimension_type = DimensionType.find(params[:id])
  end

  def new
    @dimension_type = DimensionType.new
  end

  def edit
    @dimension_type = DimensionType.find(params[:id])
  end

  def create
    @dimension_type = DimensionType.new(dimension_type_params)

    if @dimension_type.save
      flash[:notice] = "Dimension type was saved successfully."
      redirect_to @dimension_type
    else
      flash.now[:alert] = "Error creating dimension type. Please try again."
      render :new
    end
  end

  def update
    @dimension_type = DimensionType.find(params[:id])
    @dimension_type.assign_attributes(dimension_type_params)

    if @dimension_type.save
      flash[:notice] = "Dimension type was updated successfully."
      redirect_to @dimension_type
    else
      flash.now[:alert] = "Error updated dimension type. Please try again."
      render :edit
    end
  end

  def destroy
    @dimension_type = DimensionType.find(params[:id])

    if @dimension_type.destroy
      flash[:notice] = "\"#{@dimension_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the dimension type."
      render :show
    end
  end

  private

  def dimension_type_params
    params.require(:dimension_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :dimension_type_id, :_destroy] })
  end
end
