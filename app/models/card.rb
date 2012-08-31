class Card < ActiveRecord::Base
	has_and_belongs_to_many :groups
	belongs_to :deck
end
