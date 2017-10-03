class ValueItemsController < ApplicationController
  def index
    @value_items = ValueItem.all
    respond_to do |format|
      format.html
      format.csv { send_data @value_items.to_csv }
      format.xls { send_data @value_items.to_csv(col_sep: "\t") }
    end
  end

  def import
    ValueItem.import(params[:file])
    redirect_to value_items_path
    flash[:notice] = "Value items successfully imported."
  end
end
