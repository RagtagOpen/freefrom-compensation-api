class CreateMindset < ActiveRecord::Migration[5.2]
  def change
    create_table :mindsets do |t|
      t.string      :name
      t.text        :description
      t.belongs_to  :resource_category, index: true
      t.timestamps
    end
  end
end
