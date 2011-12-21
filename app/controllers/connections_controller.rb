class ConnectionsController < ApplicationController
  around_filter :update_user_list

  def login
    update_chat_room("entered") unless @channels.include? 0

    render :nothing => true
  end

  def logout
    Juggernaut.remove_channels_from_clients(@user.id, @channels)

   update_chat_room("left") unless @channels.include? 0

    render :nothing => true
  end

  private

  def update_user_list
    @user = User.find(params[:client_id])

    @channels = params[:channels].collect{|channel| channel.to_i } if params[:channels]

    yield

    Thread.new do
      users = User.find(Juggernaut.show_users_for_channels(@channels).collect{ |user| user["id"] })

      render :juggernaut => {:type => :send_to_channels, :channels => @channels } do |page|
        page.replace_html 'user_list', users.collect{ |user| "<li>"+ link_to_remote(user.login, :url => "/messages/new_private_message/#{user.id}")+"</li>" }.join
      end
    end
  end

  def update_chat_room(action)
    render :juggernaut => {:type => :send_to_channels, :channels => @channels } do |page|
      page.insert_html :bottom, 'chat_room', "<p style='color:green;font-size:20px;'>#{@user.login} has #{action} the room</p>"
      page.call :scrollChatPanel, 'chat_room'
    end
  end
end