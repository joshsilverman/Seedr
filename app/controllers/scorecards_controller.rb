class ScorecardsController < ApplicationController
  before_filter :authenticate_user!

  def audit

    if params[:handle_id]
      @cards = Card.joins({:deck => :handle}).includes(:scorecards).where('handles.id = ? AND publish = true', params[:handle_id]).order("RANDOM()").limit 50
      @grade = Handle.find(params[:handle_id]).grade
      # Handle.find(params[:handle_id]).includes(:decks => :cards).where(:publish => true).order("RANDOM()").limit 50
    elsif params[:group_id]
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    elsif params[:deck_id]
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    else
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    end

    @questions = []


    @cards.each do |card|
      group = card.groups.first
      next if group.nil? or group.question_format.nil? or group.answer_format.nil? or !card.publish
      next if card.scorecards.length > 0
      question = {
        card_id: card.id, 
        handle_id: card.deck.handle.id,
        text: card.question_formatted,
        answer: card.answer_formatted}

      question[:incorrect] = []
      i = 0
      group.cards.shuffle.each do |other_card|
        next if other_card.id == card.id
        i += 1
        question[:incorrect] << other_card.answer_formatted
        break if i == 3
      end

      @questions << question
    end
  end

  def create

    return if current_user.nil?

    @scorecard = Scorecard.where("id = ? AND user_id = ?", params[:scorecard][:card_id], current_user.id).last
    @scorecard ||= Scorecard.new

    params[:scorecard][:user_id] = current_user.id
    @scorecard.update_attributes(params[:scorecard])

    @handle = Handle.find params[:scorecard][:handle_id]

    if @scorecard.save
      render json: @handle.grade, status: :created, location: @scorecard
    end
  end

end
