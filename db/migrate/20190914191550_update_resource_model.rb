class UpdateResourceModel < ActiveRecord::Migration[5.2]
  def change
    change_table :resources do |t|
      t.text    :who
      t.text    :when
      t.text    :covered_expenses
      t.text    :attorney
      t.text    :tips, array: true, default: []
    end
  end
end
