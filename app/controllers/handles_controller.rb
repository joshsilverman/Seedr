class HandlesController < ApplicationController
  # GET /handles
  # GET /handles.json
  def index
    @handles = Handle.all

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
    @handle = Handle.find(params[:id])
  end

  # POST /handles
  # POST /handles.json
  def create
    @handle = Handle.new(params[:handle])

    respond_to do |format|
      if @handle.save
        format.html { redirect_to @handle, notice: 'Handle was successfully created.' }
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
