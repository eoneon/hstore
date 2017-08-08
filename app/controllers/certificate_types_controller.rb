class CertificateTypesController < ApplicationController
  def index
    @certificate_types = CertificateType.all
  end

  def show
    @certificate_type = CertificateType.find(params[:id])
  end

  def new
    @certificate_type = CertificateType.new
  end

  def edit
    @certificate_type = CertificateType.find(params[:id])
  end

  def create
    @certificate_type = CertificateType.new(certificate_type_params)

    if @certificate_type.save
      flash[:notice] = "Certificate type was saved successfully."
      redirect_to @certificate_type
    else
      flash.now[:alert] = "Error creating certificate type. Please try again."
      render :new
    end
  end

  def update
    @certificate_type = CertificateType.find(params[:id])
    @certificate_type.assign_attributes(certificate_type_params)

    if @certificate_type.save
      flash[:notice] = "Certificate type was updated successfully."
      redirect_to @certificate_type
    else
      flash.now[:alert] = "Error updated certificate type. Please try again."
      render :edit
    end
  end

  def destroy
    @certificate_type = CertificateType.find(params[:id])

    if @certificate_type.destroy
      flash[:notice] = "\"#{@certificate_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the certificate type."
      render :show
    end
  end

  private

  def certificate_type_params
    params.require(:certificate_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :certificate_type_id, :_destroy] })
  end
end
