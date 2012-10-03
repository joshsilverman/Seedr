class AddHandleIdToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :handle_id, :integer
  end
end
