class CreatePersons < ActiveRecord::Migration
  def change
    create_table :persons do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, null: false
      t.boolean :excluded, null: false, default: false

      t.timestamps null: false
    end
  end
end
