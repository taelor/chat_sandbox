class ChatRoomsController < ApplicationController
  before_filter :is_logged_in?
  # GET /chat_rooms
  # GET /chat_rooms.xml
  def index
    @chat_rooms = ChatRoom.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chat_rooms }
    end
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.xml
  def show
    @chat_room = ChatRoom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chat_room }
    end
  end

  # GET /chat_rooms/new
  # GET /chat_rooms/new.xml
  def new
    @chat_room = ChatRoom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chat_room }
    end
  end

  # GET /chat_rooms/1/edit
  def edit
    @chat_room = ChatRoom.find(params[:id])
  end

  # POST /chat_rooms
  # POST /chat_rooms.xml
  def create
    @chat_room = ChatRoom.new(params[:chat_room])

    respond_to do |format|
      if @chat_room.save
        flash[:notice] = 'ChatRoom was successfully created.'
        format.html { redirect_to(@chat_room) }
        format.xml  { render :xml => @chat_room, :status => :created, :location => @chat_room }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chat_room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chat_rooms/1
  # PUT /chat_rooms/1.xml
  def update
    @chat_room = ChatRoom.find(params[:id])

    respond_to do |format|
      if @chat_room.update_attributes(params[:chat_room])
        flash[:notice] = 'ChatRoom was successfully updated.'
        format.html { redirect_to(@chat_room) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chat_room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_rooms/1
  # DELETE /chat_rooms/1.xml
  def destroy
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.destroy

    respond_to do |format|
      format.html { redirect_to(chat_rooms_url) }
      format.xml  { head :ok }
    end
  end

  def send_data
      render :juggernaut => {:type => :send_to_channels, :channels => [params[:id].to_i] } do |page|
        page.insert_html :bottom, 'chat_room', "<p>#{current_user.login}: #{h params[:chat_input]}</p>"
        page.call :scrollChatPanel, 'chat_room'
      end
      render :nothing => true
  end

 	private

	def is_logged_in?
	  if logged_in?
	    true
	  else
	    flash[:error] = "You must be logged in to chat"
	    redirect_to("/login")
	    false
	  end
	end
end
