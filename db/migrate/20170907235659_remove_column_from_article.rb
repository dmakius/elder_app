class RemoveColumnFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :String, :String
  end
end
