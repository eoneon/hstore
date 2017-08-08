class AddCertificateTypeReferencesToItemFields < ActiveRecord::Migration
  def change
    add_reference :item_fields, :certificate_type, index: true, foreign_key: true
  end
end
