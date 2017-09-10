class RemoveColumnFromTable < ActiveRecord::Migration
  def change
    remove_column :tables, :String, :String
  end
end
