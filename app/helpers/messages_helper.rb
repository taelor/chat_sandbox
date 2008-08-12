module MessagesHelper
  def create_private_message(client_ids)
    top ="<div class='private_message'><div id='private_chat_room' class='private_chat_room scroller'></div><div id='chat_form'>"
    
    form = form_remote_tag(:url => { :action => :send_private_message, :client_ids => client_ids }, :complete => "$('chat_input').value = ''" )
    
    text = text_field_tag( 'chat_input', '', { :size => '50', :id => 'chat_input'} )
    
    submit = submit_tag "Chat"
    
    bottom ="</form></div><div"
    
    top+form+text+submit+bottom
  end
end
