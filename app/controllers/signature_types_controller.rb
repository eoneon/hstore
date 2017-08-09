class SignatureTypesController < ApplicationController
  def index
    @signature_types = SignatureType.all
  end

  def show
    @signature_type = SignatureType.find(params[:id])
  end

  def new
    @signature_type = SignatureType.new
  end

  def edit
    @signature_type = SignatureType.find(params[:id])
  end

  def create
    @signature_type = SignatureType.new(signature_type_params)

    if @signature_type.save
      flash[:notice] = "Signature type was saved successfully."
      redirect_to @signature_type
    else
      flash.now[:alert] = "Error creating signature type. Please try again."
      render :new
    end
  end

  def update
    @signature_type = SignatureType.find(params[:id])
    @signature_type.assign_attributes(signature_type_params)

    if @signature_type.save
      flash[:notice] = "Signature type was updated successfully."
      redirect_to @signature_type
    else
      flash.now[:alert] = "Error updated signature type. Please try again."
      render :edit
    end
  end

  def destroy
    @signature_type = SignatureType.find(params[:id])

    if @signature_type.destroy
      flash[:notice] = "\"#{@signature_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the signature type."
      render :show
    end
  end

  private

  def signature_type_params
    params.require(:signature_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :signature_type_id, :_destroy] })
  end
end
