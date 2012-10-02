class AddCardIdToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :card_id, :integer
  end
end
