class MessagesController < ApplicationController
  def new_private_message
    @client_ids = [ current_user.id, params[:id].to_i ]
    puts @client_ids
  end
  
  def send_private_message
    @client_ids = params[:client_ids].collect{|client_id| client_id.to_i } if params[:client_ids]
    
    puts @client_ids
    
    render :juggernaut => {:type => :send_to_clients, :client_ids => @client_ids } do |page|  
          
      page << "if ( $('private_chat_room') == null) {"
        page.insert_html :bottom, 'private_messages', create_private_message(@client_ids)
      page << "}"
              
      page.insert_html :bottom, 'private_chat_room', "<p>#{current_user.login}: #{h params[:chat_input]}</p>"
      page.call :scrollChatPanel, "private_chat_room"
    end
    
    render :nothing => true
  end
end
