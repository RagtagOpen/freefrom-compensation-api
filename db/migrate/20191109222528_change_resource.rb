class ChangeResource < ActiveRecord::Migration[5.2]
  def change
    change_table :resources do |t|
      t.text  :where
      t.text  :what_to_expect, default: [], array: true
      t.text  :what_if_i_disagree, default: [], array: true
      t.text  :resources, default: [], array: true
      t.text  :steps, default: [], array: true
    end

    drop_table :resource_steps
  end
end
