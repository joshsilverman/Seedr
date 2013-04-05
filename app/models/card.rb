class Card < ActiveRecord::Base
  has_and_belongs_to_many :groups
  belongs_to :deck
  has_many :scorecards

  def question_formatted
    return unless groups
    format = groups.first.question_format
    eval "\"#{format}\""
  end

  def answer_formatted
    return unless groups
    format = groups.first.answer_format
    eval "\"#{format}\""
  end
end
