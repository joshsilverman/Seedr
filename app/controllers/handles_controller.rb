class HandlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:export]

  # GET /handles
  # GET /handles.json 
  def index
    @handles = Handle.includes(:decks => {:cards => :scorecards}).order('created_at ASC').all

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
    @handle = Handle.includes(:decks => {:groups => {:cards => [:scorecards, :groups]}}).find(params[:id])

    # @deck_grades = {}
    # @handle.decks.each {|d| @deck_grades[d.id] = d.grade}
  end

  def export
    questions = []
    @handle = Handle.find(params[:id])
    cards = []
    @handle.decks.each {|d| d.groups.each {|g| cards += g.cards}} if @handle
    cards.each do |card|
      group = card.groups.first
      question = {}

      next if card.publish == false
      next if group.nil?
      next if group.question_format.nil? or group.answer_format.nil?
      next if group.question_format.empty? or group.answer_format.empty?

      question[:card_id] = card.id
      question[:text] = card.question_formatted
      question[:answer] = card.answer_formatted
      question[:incorrect] = []

      question[:false_answers] = []
      i = 0
      group.cards.shuffle.each do |other_card|
        next if other_card.id == card.id
        next if other_card.answer_formatted == card.answer_formatted
        next if question[:incorrect].include? other_card.answer_formatted

        i += 1
        question[:false_answers] << other_card.answer_formatted
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

    @deck = Deck.find_or_create_by_quizlet_id params[:handle][:decks][:quizlet_id]
    params[:handle].delete :decks
    @handle = Handle.create(params[:handle])
    @deck.handle_id = @handle.id

    require "net/https"
    require "uri"
    uri = URI.parse("https://api.quizlet.com/2.0/sets/#{@deck.quizlet_id}?client_id=ABPPhBBUAN&whitespace=1")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    @qdeck = JSON.parse response.body

    @deck.save

    @group = Group.find_or_create_by_deck_id_and_default @deck.id, true
    @group.update_attributes :name => "Default"

    @deck.title = @qdeck['title']
    @qdeck['terms'].each do |t|
      card = Card.find_or_create_by_quizlet_id t['id']
      card.front = t['term']
      card.back = t['definition']
      @deck.cards << card
      @group.cards << card
      card.save
    end

    redirect_to "/decks/#{@deck.id}/sort"
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
