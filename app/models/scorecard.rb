class Scorecard < ActiveRecord::Base

  belongs_to :user
  belongs_to :card
  belongs_to :handle

  def self.good
    Scorecard.where("awk IS NULL AND length IS NULL AND level IS NULL AND error IS NULL AND inapp IS NULL").select([:id, :handle_id]).group('handle_id').count
  end

  def self.bad
    Scorecard.where("awk = ? or length = ? or level = ? or error = ? or inapp = ?", true, true, true, true, true).select([:id, :handle_id]).group('handle_id').count
  end

end
