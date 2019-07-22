class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string  :state
      t.text    :time
      t.text    :cost
      t.text    :award
      t.text    :likelihood
      t.text    :safety
      t.text    :story
      t.text    :challenges

      t.belongs_to  :resource_category

      t.timestamps
    end

    add_index :resources, [:resource_category_id, :state], unique: true
  end
end
