class AddUserInfo < ActiveRecord::Migration
  def change
    add_column :users, :occupation, :string
    add_column :users, :about, :string
    add_column :users, :education, :string
    add_column :users, :gender, :string
    add_column :users, :location, :string
  end
end
