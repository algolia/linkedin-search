class NonSearchableUsersCounter < ActiveRecord::Migration
  def change
    add_column :users, :non_searchable_counter, :integer, null: false, default: 0
  end
end
