class Deck < ActiveRecord::Base
	belongs_to :handle
	has_many :cards
	has_many :groups
end
