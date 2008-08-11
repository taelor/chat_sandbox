class ConnectionsController < ApplicationController
  around_filter :update_user_list
  
  def login
    render :juggernaut => {:type => :send_to_channels, :channels => @channels } do |page|
      page.insert_html :bottom, 'chat_room', "<p style='color:green;font-size:20px;'>#{@user.login} has entered the room</p>"
      page.call :scrollChatPanel
    end
    
    #render :nothing => true
  end

  def logout
    Juggernaut.remove_channels_from_clients(@user.id, @channels)
    
    render :juggernaut => {:type => :send_to_channels, :channels => @channels } do |page|
      page.insert_html :bottom, 'chat_room', "<p style='color:green;font-size:20px;'>#{@user.login} has left the room</p>"
      page.call :scrollChatPanel
    end
    
    render :nothing => true
  end

  private
  
  def update_user_list
    @user = User.find(params[:client_id])
    
    @channels = params[:channels].collect{|channel| channel.to_i }
    
    yield

    Thread.new do
      users = User.find(Juggernaut.show_users_for_channels(@channels).collect{ |user| user["id"] })
        
      render :juggernaut => {:type => :send_to_channels, :channels => @channels } do |page|
        page.replace_html 'user_list', users.collect{ |user| "<li>#{user.login}</li>" }.join
      end
    end
  end
end