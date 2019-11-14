class AddSlugs < ActiveRecord::Migration[5.2]
  def change
    change_table :resource_categories do |t|
      t.string  :slug
      t.remove  :short_description,
                :icon,
                :seo_title,
                :seo_description,
                :seo_keywords,
                :share_image
    end

    change_table :mindsets do |t|
      t.string  :slug
    end

    add_index :mindsets, :slug, uniqueness: true
    add_index :resource_categories, :slug, uniqueness: true
  end
end
