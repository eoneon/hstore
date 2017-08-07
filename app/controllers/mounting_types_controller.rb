class MountingTypesController < ApplicationController
  def index
    @mounting_types = MountingType.all
  end

  def show
    @mounting_type = MountingType.find(params[:id])
  end

  def new
    @mounting_type = MountingType.new
  end

  def edit
    @mounting_type = MountingType.find(params[:id])
  end

  def create
    @mounting_type = MountingType.new(mounting_type_params)

    if @mounting_type.save
      flash[:notice] = "Mounting Type was saved successfully."
      redirect_to @mounting_type
    else
      flash.now[:alert] = "Error creating ItemType. Please try again."
      render :new
    end
  end

  def update
    @mounting_type = MountingType.find(params[:id])
    @mounting_type.assign_attributes(mounting_type_params)

    if @mounting_type.save
      flash[:notice] = "Mounting type was updated successfully."
      redirect_to @mounting_type
    else
      flash.now[:alert] = "Error updated mounting type. Please try again."
      render :edit
    end
  end

  def destroy
    @mounting_type = MountingType.find(params[:id])

    if @mounting_type.destroy
      flash[:notice] = "\"#{@mounting_type.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the mounting type."
      render :show
    end
  end

  private

  #https://stackoverflow.com/questions/18436741/rails-4-strong-parameters-nested-objects
  #https://stackoverflow.com/questions/24584816/rails-4-deleting-nested-attributes-works-on-create-but-not-on-edit-update - edit
  def mounting_type_params
    params.require(:mounting_type).permit(:id, :name, { :fields_attributes => [:id, :field_type, :name, :required, :mounting_type_id, :_destroy] })
    #params.require(:item_type).permit(:name)
  end
end
