class CreateResourceLink < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_links do |t|
      t.belongs_to  :resource, index: true
      t.text        :description
      t.string      :url
    end
  end
end
