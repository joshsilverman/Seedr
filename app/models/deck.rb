class Deck < ActiveRecord::Base
	belongs_to :handle
	has_many :cards
	has_many :groups

  # def grade
  #   bad_scorecards = Scorecard.bad "card_id IN (#{self.cards.ids})"
  #   good_scorecards = Scorecard.good "card_id IN (#{self.cards.ids})"

  #   good = good_scorecards
  #   bad = bad_scorecards
  #   all = good + bad
  #   grade = nil
  #   grade =  (good / all) if all > 0

  #   population = self.cards.count
  #   sample_size = all
  #   sample_size_finite = sample_size.to_f / (1 + ((sample_size-1).to_f/population))
  #   percentage = grade
  #   percentage = 0.99 if grade == 1
  #   percentage = 0.01 if grade == 0

  #   z = 1.96
  #   ci = nil
  #   ci = Math.sqrt((z**2*percentage*(1-percentage))/sample_size_finite) if sample_size > 0

  #   {:good => good, :bad => bad, :grade => grade, :percentage => percentage, :ci => ci, :sample_size => sample_size, :sample_size_finite => sample_size_finite, :population => population}
  # end
end
