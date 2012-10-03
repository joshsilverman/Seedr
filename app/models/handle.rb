class Handle < ActiveRecord::Base
	has_many :decks
  has_many :scorecards
end
