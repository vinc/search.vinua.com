class AddBlockedDomainsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blocked_domains, :string, array: true, default: []
  end
end
