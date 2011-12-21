class MessagesController < ApplicationController
  def new_private_message
    @client_ids = [ current_user.id, params[:id].to_i ]
  end

  def send_private_message
    @client_ids = params[:client_ids].collect{|client_id| client_id.to_i } if params[:client_ids]

    private_chat_room_id = 'private_chat_room_'+@client_ids.join('_')
    private_chat_input_id = 'private_chat_input_'+@client_ids.join('_')

    render :juggernaut => {:type => :send_to_clients, :client_ids => @client_ids } do |page|

      page << "if ( $('#{private_chat_room_id}') == null) {"
        page.insert_html :bottom, 'private_messages', create_private_message(@client_ids)
      page << "}"

      page.insert_html :bottom, private_chat_room_id, "<p>#{current_user.login}: #{h params[private_chat_input_id]}</p>"
      page.call :scrollChatPanel, private_chat_room_id
    end

    render :nothing => true
  end
end
