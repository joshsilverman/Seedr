class AddDefaultToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :default, :boolean
  end
end
