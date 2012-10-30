class HandlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:export]

  # GET /handles
  # GET /handles.json 
  def index
    @handles = Handle.includes(:decks => :cards).all

    @grades = {}
    @handles.each {|h| @grades[h.id] = h.grade}
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
        if group.answer_format.include? "back"
          next if other_card.back == card.back
        else
          next if other_card.front == card.front        
        end
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
