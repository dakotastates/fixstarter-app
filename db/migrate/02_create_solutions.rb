class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :name
      t.integer :user_id
      t.integer :problem_id
      t.timestamps null: false
    end
  end
end
