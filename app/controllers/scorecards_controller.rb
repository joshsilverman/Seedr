class ScorecardsController < ApplicationController

  def create

    @scorecard = Scorecard.where("id = ? AND user_id = ?", params[:scorecard][:card_id], current_user.id).last
    @scorecard ||= Scorecard.new

    puts @scorecard.nil?
    puts params

    @scorecard.update_attributes(params[:scorecard])

    if @scorecard.save
      render json: @scorecard, status: :created, location: @scorecard
    end
  end

end
