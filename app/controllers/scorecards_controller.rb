class ScorecardsController < ApplicationController

  def audit

    if params[:handle_id]
      @cards = Card.joins({:deck => :handle}).includes(:scorecards).where('handles.id = ? AND publish = true', params[:handle_id]).order("RANDOM()").limit 20
      # Handle.find(params[:handle_id]).includes(:decks => :cards).where(:publish => true).order("RANDOM()").limit 50
    elsif params[:group_id]
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    elsif params[:deck_id]
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    else
      # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    end
    # @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50

    @questions = []

    @cards.each do |card|
      group = card.groups.first
      next if group.nil? or group.question_format.nil? or group.answer_format.nil? or !card.publish
      next if card.scorecards.length > 0
      question = {:card_id => card.id, :handle_id => card.deck.handle.id}

      question_parts = group.question_format.split /\#{|}/
      front = (question_parts[1] == "front") ? true : false
      question['text'] = ""
      question_parts.each_with_index do |part, i|
        if i == 1
          question['text'] += card[:front] if front
          question['text'] += card[:back] if !front
        else
          question['text'] += part
        end

        question['answer'] = group.answer_format.gsub('#{front}', card.front).gsub('#{back}', card.back)
        question['incorrect'] = []
        i = 0
        group.cards.shuffle.each do |other_card|
          next if other_card.id == card.id
          i += 1
          question['incorrect'] << group.answer_format.gsub('#{front}', other_card.front).gsub('#{back}', other_card.back)
          break if i == 3
        end
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

    if @scorecard.save
      render json: @scorecard, status: :created, location: @scorecard
    end
  end

end
