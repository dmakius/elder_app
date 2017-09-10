class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.date :date
      t.string :title
      t.string :string
      t.string :publication
      t.text :url

      t.timestamps null: false
    end
  end
end
