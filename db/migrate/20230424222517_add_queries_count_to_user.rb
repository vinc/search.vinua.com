class AddQueriesCountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :queries_count, :integer
  end
end
