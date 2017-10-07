class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:sort)
    respond_to do |format|
      format.html
      format.csv { send_data @categories.to_csv }
      format.xls { send_data @categories.to_csv(col_sep: "\t") }
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.find(category_params)

    if @category.save
      flash[:notice] = "Category was saved successfully."
      redirect_to @categories
    else
      flash.now[:alert] = "Error creating category. Please try again."
      render :edit
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    @category.assign_attributes(category_params)

    if @category.save
      flash[:notice] = "Category was updated successfully."
      redirect_to @categories
    else
      flash.now[:alert] = "Error updated category. Please try again."
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:notice] = "Item was deleted successfully."
    else
      flash.now[:alert] = "There was an error deleting the item."
    end
    redirect_to @categories
  end

  def import
    Category.import(params[:file])
    redirect_to categories_path
    flash[:notice] = "Categories successfully imported."
  end

  # def sort_up
  #   @category = Category.find(params[:id])
  #   prev = Category.where("sort = ?", @category.sort - 1)
  #   prev.sort = prev.sort + 1
  #   prev.save!
  #   @category.sort = @category.sort - 1
  #   @category.save!
  #   redirect_to :back
  # end
  #
  # def sort_down
  # end

  private

  def category_params
    params.require(:category).permit(:name, :sort)
  end

  # def update_sort
  # end
end
