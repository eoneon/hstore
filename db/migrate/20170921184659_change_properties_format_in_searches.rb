class ChangePropertiesFormatInSearches < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')

    def up
      change_column :searches, :properties, :hstore
    end

    def down
      change_column :searches, :properties, :string
    end
  end
end
