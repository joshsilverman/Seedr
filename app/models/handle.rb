class Handle < ActiveRecord::Base
	has_many :decks
  has_many :scorecards

  def grade
    bad_scorecards = Scorecard.bad :handle_id => self.id
    good_scorecards = Scorecard.good :handle_id => self.id

    good = good_scorecards.to_i.to_f
    bad = bad_scorecards.to_i.to_f
    all = good + bad
    grade = nil
    grade =  (good / all) if all > 0

    population = self.decks.map{|d| d.cards.count}.sum
    sample_size = all
    sample_size_finite = sample_size.to_f / (1 + ((sample_size-1).to_f/population))
    percentage = grade
    percentage = 0.99 if grade == 1
    percentage = 0.01 if grade == 0

    z = 1.96
    ci = nil
    ci = Math.sqrt((z**2*percentage*(1-percentage))/sample_size_finite) if sample_size > 0

    {:good => good, :bad => bad, :grade => grade, :percentage => percentage, :ci => ci, :sample_size => sample_size, :sample_size_finite => sample_size_finite, :population => population}
  end
end
