class AddProblemInfo < ActiveRecord::Migration
  def change
    add_column :problems, :description, :string
    add_column :problems, :category, :string
    add_column :problems, :severity, :string
    add_column :problems, :tags, :string
    add_column :problems, :location, :string
    add_column :problems, :status, :boolean
  end
end
