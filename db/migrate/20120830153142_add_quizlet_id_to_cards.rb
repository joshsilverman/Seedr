class AddQuizletIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :quizlet_id, :integer
  end
end
