class AddColumnSilencedToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :silenced, :boolean
  end
end
