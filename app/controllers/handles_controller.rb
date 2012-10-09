class HandlesController < ApplicationController
  # GET /handles
  # GET /handles.json 
  def index
    @handles = Handle.includes(:decks => :cards).all

    bad_scorecards = Scorecard.where("awk = ? or length = ? or level = ? or error = ? or inapp = ?", true, true, true, true, true).select([:id, :handle_id]).group('handle_id').count
    good_scorecards = Scorecard.where("awk IS NULL AND length IS NULL AND level IS NULL AND error IS NULL AND inapp IS NULL").select([:id, :handle_id]).group('handle_id').count

    @grades = {}
    @handles.each do |h|
      good = good_scorecards[h.id].to_i.to_f
      bad = bad_scorecards[h.id].to_i.to_f
      all = good + bad
      grade = nil
      grade =  (good / all) if all > 0

      population = h.decks.map{|d| d.cards.count}.sum
      sample_size = all
      sample_size_finite = sample_size.to_f / (1 + ((sample_size-1).to_f/population))
      percentage = grade
      percentage = 0.99 if grade == 1
      percentage = 0.01 if grade == 0

      z = 1.96
      ci = nil
      ci = Math.sqrt((z**2*percentage*(1-percentage))/sample_size_finite) if sample_size > 0

      @grades[h.id] = {:good => good, :bad => bad, :grade => grade, :percentage => percentage, :ci => ci, :sample_size => sample_size, :sample_size_finite => sample_size_finite, :population => population}
    end
    ap @grades


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @handles }
    end
  end

  # GET /handles/1
  # GET /handles/1.json
  def show
    @handle = Handle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @handle }
    end
  end

  # GET /handles/new
  # GET /handles/new.json
  def new
    @handle = Handle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @handle }
    end
  end

  # GET /handles/1/edit
  def edit
    @handle = Handle.includes(:decks => {:groups => {:cards => :groups}}).find(params[:id])
  end

  def export
    questions = []
    @handle = Handle.find(params[:id])
    cards = []
    @handle.decks.each {|d| d.groups.each {|g| cards += g.cards}} if @handle
    cards.each do |card|
      group = card.groups.first
      question = {}
      next if group.nil? or group.question_format.nil? or group.answer_format.nil? or !card.publish
      question[:card_id] = card.id
      question_parts = group.question_format.split /\#{|}/
      # front = (question_parts[1] == "front") ? true : false
      question[:text] = group.question_format.gsub('#{front}', card.front).gsub('#{back}', card.back)
      question[:answer] = group.answer_format.gsub('#{front}', card.front).gsub('#{back}', card.back)

      question[:false_answers] = []
      i = 0
      group.cards.shuffle.each do |other_card|
        next if other_card.id == card.id
        i += 1
        question[:false_answers] << group.answer_format.gsub('#{front}', other_card.front).gsub('#{back}', other_card.back)
        break if i == 3
      end
      questions << question
    end

    respond_to do |format|
      format.json { render json: questions }
    end
  end

  # POST /handles
  # POST /handles.json
  def create
    @handle = Handle.new(params[:handle])

    respond_to do |format|
      if @handle.save
        format.html { redirect_to edit_handle_path(@handle), notice: 'Handle was successfully created.' }
        format.json { render json: @handle, status: :created, location: @handle }
      else
        format.html { render action: "new" }
        format.json { render json: @handle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /handles/1
  # PUT /handles/1.json
  def update
    @handle = Handle.find(params[:id])

    respond_to do |format|
      if @handle.update_attributes(params[:handle])
        format.html { redirect_to @handle, notice: 'Handle was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @handle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /handles/1
  # DELETE /handles/1.json
  def destroy
    @handle = Handle.find(params[:id])
    @handle.destroy

    respond_to do |format|
      format.html { redirect_to handles_url }
      format.json { head :ok }
    end
  end
end
