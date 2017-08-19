class SubstrateTypesController < ApplicationController
  def index
    @substrate_types = SubstrateType.all
  end

  def show
    @substrate_type = SubstrateType.find(params[:id])
  end

  def new
    @substrate_type = SubstrateType.new
  end

  def edit
    @substrate_type = SubstrateType.find(params[:id])
  end

  def create
    @substrate_type = SubstrateType.new(substrate_type_params)

    if @substrate_type.save
      flash[:notice] = "Substrate type was saved successfully."
      redirect_to @substrate_type
    else
      flash.now[:alert] = "Error creating substrate type. Please try again."
      render :new
    end
  end

  def update
    @substrate_type = SubstrateType.find(params[:id])
    @substrate_type.assign_attributes(substrate_type_params)

    if @substrate_type.save
      flash[:notice] = "Substrate type was updated successfully."
      redirect_to @substrate_type
    else
      flash.now[:alert] = "Error updated substrate type. Please try again."
      render :edit
    end
  end

  def destroy
    @substrate_type = SubstrateType.find(params[:id])

    if @substrate_type.destroy
      flash[:notice] = "\"#{@substrate_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the substrate type."
      render :show
    end
  end

  private

  def substrate_type_params
    params.require(:substrate_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :substrate_type_id, :_destroy] })
  end
end
