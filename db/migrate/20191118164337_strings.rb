class Strings < ActiveRecord::Migration[5.2]
  def change
    rename_column :resources, :challenges, :challenges_text
    add_column :resources, :challenges, :text, array: true, default: []
    remove_column :resources, :challenges_text

    rename_column :resources, :what_to_expect, :what_to_expect_text
    add_column :resources, :what_to_expect, :text, array: true, default: []
    remove_column :resources, :what_to_expect_text

    rename_column :resources, :what_if_i_disagree, :what_if_i_disagree_text
    add_column :resources, :what_if_i_disagree, :text, array: true, default: []
    remove_column :resources, :what_if_i_disagree_text
  end
end
