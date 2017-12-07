class DisclaimerTypesController < ApplicationController
  def index
    @disclaimer_types = DisclaimerType.all
  end

  def show
    @disclaimer_type = DisclaimerType.find(params[:id])
  end

  def new
    @disclaimer_type = DisclaimerType.new
  end

  def edit
    @disclaimer_type = DisclaimerType.find(params[:id])
  end

  def create
    @disclaimer_type = DisclaimerType.new(disclaimer_type_params)

    if @disclaimer_type.save
      flash[:notice] = "Dimension type was saved successfully."
      redirect_to @disclaimer_type
    else
      flash.now[:alert] = "Error creating disclaimer type. Please try again."
      render :new
    end
  end

  def update
    @disclaimer_type = DisclaimerType.find(params[:id])
    @disclaimer_type.assign_attributes(disclaimer_type_params)

    if @disclaimer_type.save
      flash[:notice] = "Dimension type was updated successfully."
      redirect_to @disclaimer_type
    else
      flash.now[:alert] = "Error updated disclaimer type. Please try again."
      render :edit
    end
  end

  def destroy
    @disclaimer_type = DisclaimerType.find(params[:id])

    if @disclaimer_type.destroy
      flash[:notice] = "\"#{@disclaimer_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the disclaimer type."
      render :show
    end
  end

  private

  def disclaimer_type_params
    params.require(:disclaimer_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :disclaimer_type_id, :_destroy] })
  end
end
