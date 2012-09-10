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
    @group = Group.where(:id => params[:group_id]).first


    @cards.each do |card|
      @group = Group.create :deck_id => card.deck_id if @group.nil?

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
