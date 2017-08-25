class TitlesController < ApplicationController
  def index
    @titles = Title.all
  end

  def show
    @title = Title.find(params[:id])
  end

  def new
    @title = Title.new
  end

  def create
    @title = Title.new(title_params)

    if @title.save
      flash[:notice] = "Title was saved successfully."
      redirect_to @title
    else
      flash.now[:alert] = "Error creating Title. Please try again."
      render :new
    end
  end

  def edit
    @title = Title.find(params[:id])
  end

  def update
    @title = Title.find(params[:id])
    @title.assign_attributes(title_params)

    if @title.save
      flash[:notice] = "Title was updated successfully."
      redirect_to @title
    else
      flash.now[:alert] = "Error updated Title. Please try again."
      render :edit
    end
  end

  def destroy
    @title = Title.find(params[:id])

    if @title.destroy
      flash[:notice] = "\"#{@title.sku}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the Title."
      render :show
    end
  end

  private

  def title_params
    params.require(:title).permit(:title)
  end
end
