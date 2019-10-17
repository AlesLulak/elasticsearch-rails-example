class AddExcludedToPeople < ActiveRecord::Migration
  def change
    add_column :people, :excluded, :boolean
  end
end
