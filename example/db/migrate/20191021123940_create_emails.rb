class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :person_id
      t.string :email, null: false

      t.timestamps null: false
    end

    remove_column :persons, :email
    add_foreign_key :emails, :persons
  end
end
