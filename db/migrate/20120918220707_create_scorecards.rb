class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.boolean :awk
      t.boolean :length
      t.boolean :level
      t.boolean :error
      t.boolean :inapp

      t.timestamps
    end
  end
end
