class CreateItems < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :items do |t|
      t.string 'name'
      t.hstore :properties
      
      t.timestamps null: false
    end
  end
end
