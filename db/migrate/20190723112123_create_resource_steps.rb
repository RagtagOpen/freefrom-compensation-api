class CreateResourceSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_steps do |t|
      t.integer     :number 
      t.text        :description
      t.belongs_to  :resource, index: true
      t.timestamps
    end
  end
end
