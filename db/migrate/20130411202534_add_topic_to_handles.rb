class AddTopicToHandles < ActiveRecord::Migration
  def change
    add_column :handles, :topic, :string
  end
end
