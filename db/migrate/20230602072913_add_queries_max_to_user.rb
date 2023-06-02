class AddQueriesMaxToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :queries_max, :integer, default: 10
  end
end
