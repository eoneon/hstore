class ReserveTypesController < ApplicationController
  def index
    @reserve_types = ReserveType.all
  end

  def show
    @reserve_type = ReserveType.find(params[:id])
  end

  def new
    @reserve_type = ReserveType.new
  end

  def edit
    @reserve_type = ReserveType.find(params[:id])
  end

  def create
    @reserve_type = ReserveType.new(reserve_type_params)

    if @reserve_type.save
      flash[:notice] = "ReserveType was saved successfully."
      redirect_to @reserve_type
    else
      flash.now[:alert] = "Error creating ReserveType. Please try again."
      render :new
    end
  end

  def update
    @reserve_type = ReserveType.find(params[:id])
    @reserve_type.assign_attributes(reserve_type_params)

    if @reserve_type.save
      flash[:notice] = "reserve_type was updated successfully."
      redirect_to @reserve_type
    else
      flash.now[:alert] = "Error updated reserve_type. Please try again."
      render :edit
    end
  end

  def destroy
    @reserve_type = ReserveType.find(params[:id])

    if @reserve_type.destroy
      flash[:notice] = "\"#{@reserve_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the reserve_type."
      render :show
    end
  end

  private

  def reserve_type_params
    params.require(:reserve_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :reserve_type_id, :_destroy] })
  end
end
