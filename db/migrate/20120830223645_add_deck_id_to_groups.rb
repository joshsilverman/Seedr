class AddDeckIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :deck_id, :integer
  end
end
