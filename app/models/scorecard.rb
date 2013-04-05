class Scorecard < ActiveRecord::Base

  belongs_to :user
  belongs_to :card
  belongs_to :handle

  def self.good opts
    Scorecard.where(opts).where("awk IS NULL AND length IS NULL AND level IS NULL AND error IS NULL AND inapp IS NULL").count
  end

  def self.bad opts
    Scorecard.where(opts).where("awk = ? or length = ? or level = ? or error = ? or inapp = ?", true, true, true, true, true).count
  end

end
