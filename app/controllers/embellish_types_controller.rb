class EmbellishTypesController < ApplicationController
  def index
    @embellish_types = EmbellishType.all
  end

  def show
    @embellish_type = EmbellishType.find(params[:id])
  end

  def new
    @embellish_type = EmbellishType.new
  end

  def edit
    @embellish_type = EmbellishType.find(params[:id])
  end

  def create
    @embellish_type = EmbellishType.new(embellish_type_params)

    if @embellish_type.save
      flash[:notice] = "Embellish type was saved successfully."
      redirect_to @embellish_type
    else
      flash.now[:alert] = "Error creating embellish type. Please try again."
      render :new
    end
  end

  def update
    @embellish_type = EmbellishType.find(params[:id])
    @embellish_type.assign_attributes(embellish_type_params)

    if @embellish_type.save
      flash[:notice] = "Embellish type was updated successfully."
      redirect_to @embellish_type
    else
      flash.now[:alert] = "Error updated embellish type. Please try again."
      render :edit
    end
  end

  def destroy
    @embellish_type = EmbellishType.find(params[:id])

    if @embellish_type.destroy
      flash[:notice] = "\"#{@embellish_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the embellish type."
      render :show
    end
  end

  private

  def embellish_type_params
    params.require(:embellish_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :embellish_type_id, :_destroy] })
  end
end
