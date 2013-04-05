class AddPublishedToHandles < ActiveRecord::Migration
  def change
    add_column :handles, :published, :boolean
  end
end
