class DecksController < ApplicationController
  # GET /decks
  # GET /decks.json
  def index
    @decks = Deck.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @decks }
    end
  end

  # GET /decks/1
  # GET /decks/1.json
  def show
    @deck = Deck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deck }
    end
  end

  # GET /decks/new
  # GET /decks/new.json
  def new
    @deck = Deck.create :handle_id => params[:handle_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deck }
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = Deck.find(params[:id])

    # require "net/https"
    # require "uri"
    # uri = URI.parse("https://api.quizlet.com/2.0/sets/#{@deck.quizlet_id}?client_id=ABPPhBBUAN&whitespace=1")
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # request = Net::HTTP::Get.new(uri.request_uri)
    # response = http.request(request)
    # @qdeck = JSON.parse response.body

    # @deck.title = @qdeck['title']
    # @qdeck['terms'].each do |t|
    #   card = Card.find_or_create_by_quizlet_id t['id']
    #   card.front = t['term']
    #   card.back = t['definition']
    #   @deck.cards << card
    #   card.save
    # end

    @cards = []
    @groups = {}
    @deck.cards.each do |card|
      if card.groups.count == 0
        @cards.push card
      else
        group = card.groups.first
        if @groups[group.id].kind_of?(Array)
          @groups[group.id].push card
        else
          @groups[group.id] = [card]
        end
      end
    end
  end

  # POST /decks
  # POST /decks.json
  def create
    @deck = Deck.new(params[:deck])

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: 'Deck was successfully created.' }
        format.json { render json: @deck, status: :created, location: @deck }
      else
        format.html { render action: "new" }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /decks/1
  # PUT /decks/1.json
  def update
    @deck = Deck.find(params[:id])

    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        format.html { redirect_to @deck, notice: 'Deck was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1
  # DELETE /decks/1.json
  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to decks_url }
      format.json { head :ok }
    end
  end
end
