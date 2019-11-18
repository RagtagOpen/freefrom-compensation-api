class MakeChallengesArray < ActiveRecord::Migration[5.2]
  def change
    change_column :resources, :challenges, :text, array: true, default: [], using: "(string_to_array(challenges, ','))"
  end
end
