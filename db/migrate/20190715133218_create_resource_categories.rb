class CreateResourceCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_categories do |t|
      t.string  :name
      t.text    :short_description
      t.text    :description
      t.binary  :icon
      t.string  :seo_title
      t.text    :seo_description
      t.string  :seo_keywords, array: true
      t.binary  :share_image

      t.timestamps
    end
  end
end
