class RemoveStringFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :string, :string
  end
end
