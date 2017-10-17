class EditionTypesController < ApplicationController
  def index
    @edition_types = EditionType.all
  end

  def show
    @edition_type = EditionType.find(params[:id])
  end

  def new
    @edition_type = EditionType.new
  end

  def edit
    @edition_type = EditionType.find(params[:id])
  end

  def create
    @edition_type = EditionType.new(edition_type_params)

    if @edition_type.save
      flash[:notice] = "Edition type was saved successfully."
      redirect_to @edition_type
    else
      flash.now[:alert] = "Error creating edition type. Please try again."
      render :new
    end
  end

  def update
    @edition_type = EditionType.find(params[:id])
    @edition_type.assign_attributes(edition_type_params)

    if @edition_type.save
      flash[:notice] = "Edition type was updated successfully."
      redirect_to @edition_type
    else
      flash.now[:alert] = "Error updated edition type. Please try again."
      render :edit
    end
  end

  def destroy
    @edition_type = EditionType.find(params[:id])

    if @edition_type.destroy
      flash[:notice] = "\"#{@edition_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the edition type."
      render :show
    end
  end

  private

  def edition_type_params
    params.require(:edition_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :edition_type_id, :_destroy] })
  end
end
