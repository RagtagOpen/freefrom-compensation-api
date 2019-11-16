class ArrayFields < ActiveRecord::Migration[5.2]
  def change
    change_column :resources, :what_to_expect, :text, array: true, default: [], using: "(string_to_array(what_to_expect, ','))"
    change_column :resources, :what_if_i_disagree, :text, array: true, default: [], using: "(string_to_array(what_if_i_disagree, ','))"
  end
end
