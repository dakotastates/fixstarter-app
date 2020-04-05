class AddSolutionsInfo < ActiveRecord::Migration
  def change
    add_column :solutions, :description, :string


  end
end
