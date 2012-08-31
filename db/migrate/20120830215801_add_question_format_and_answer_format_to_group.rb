class AddQuestionFormatAndAnswerFormatToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :question_format, :text
    add_column :groups, :answer_format, :text
  end
end
