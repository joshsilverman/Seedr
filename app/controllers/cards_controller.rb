class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  def audit
    @cards = Card.includes([:scorecards, {:deck => :handle}]).where(:publish => true).order("RANDOM()").limit 50
    @questions = []

    @cards.each do |card|
      group = card.groups.first
      next if group.nil? or group.question_format.nil? or group.answer_format.nil? or !card.publish
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

  # GET /cards/1
  # GET /cards/1.json
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    @card = Card.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id])
  end

  def group

    @cards = Card.where(:id => params[:id].split(",")).all

    puts params[:group_id]
    puts @cards
    puts @cards.count > 0
    if params[:group_id] == 'undefined' and @cards.count > 0
      @group = Group.create :deck_id => @cards.first.deck_id
    else
      @group = Group.where(:id => params[:group_id]).first
    end

    @cards.each do |card|

      CardsGroup.where(:card_id => card.id).delete_all
      card.groups << @group
    end

    render :text => @group.id
  end

  def ungroup
    @cards = Card.where(:id => params[:id].split(",")).all
    
    @cards.each do |card|
      CardsGroup.where(:card_id => card.id).delete_all
    end

    render :text => "did it"
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render json: @card, status: :created, location: @card }
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :ok }
    end
  end
end
