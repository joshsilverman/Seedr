class Card < ActiveRecord::Base
  has_and_belongs_to_many :groups
  belongs_to :deck
  has_many :scorecards

  def question_formatted format = nil
    return unless groups
    format ||= groups.first.question_format.gsub('&quot;', "\"")
    begin 
      eval "\"#{format}\""
    rescue Exception => exc
      ""
    end
  end

  def answer_formatted format = nil
    return unless groups
    format ||= groups.first.answer_format.gsub('&quot;', "\"")
    begin
      eval "\"#{format}\""
    rescue Exception => exc
      ""
    end
  end
end
