class AddCustomerTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :customer_token, :string
  end

  def down
    remove_column :users, :customer_token
  end
end
