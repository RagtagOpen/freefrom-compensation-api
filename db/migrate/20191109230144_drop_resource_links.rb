class DropResourceLinks < ActiveRecord::Migration[5.2]
  def change
    drop_table :resource_links
  end
end
