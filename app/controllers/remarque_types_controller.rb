class RemarqueTypesController < ApplicationController
  def index
    @remarque_types = RemarqueType.all
  end

  def show
    @remarque_type = RemarqueType.find(params[:id])
  end

  def new
    @remarque_type = RemarqueType.new
  end

  def edit
    @remarque_type = RemarqueType.find(params[:id])
  end

  def create
    @remarque_type = RemarqueType.new(remarque_type_params)

    if @remarque_type.save
      flash[:notice] = "Remarque type was saved successfully."
      redirect_to @remarque_type
    else
      flash.now[:alert] = "Error creating remarque type. Please try again."
      render :new
    end
  end

  def update
    @remarque_type = RemarqueType.find(params[:id])
    @remarque_type.assign_attributes(remarque_type_params)

    if @remarque_type.save
      flash[:notice] = "Remarque type was updated successfully."
      redirect_to @remarque_type
    else
      flash.now[:alert] = "Error updated remarque type. Please try again."
      render :edit
    end
  end

  def destroy
    @remarque_type = RemarqueType.find(params[:id])

    if @remarque_type.destroy
      flash[:notice] = "\"#{@remarque_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the remarque type."
      render :show
    end
  end

  private

  def remarque_type_params
    params.require(:remarque_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :remarque_type_id, :_destroy] })
  end
end
