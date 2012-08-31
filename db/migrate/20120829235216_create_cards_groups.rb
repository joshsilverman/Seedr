class CreateCardsGroups < ActiveRecord::Migration
  def change
    create_table :cards_groups do |t|
      t.integer :card_id
      t.integer :group_id

      t.timestamps
    end
  end
end
