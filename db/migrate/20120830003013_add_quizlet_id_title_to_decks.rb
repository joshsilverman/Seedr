class AddQuizletIdTitleToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :quizlet_id, :integer
    add_column :decks, :title, :string
  end
end
