module MessagesHelper
  def create_private_message(client_ids)
    users = User.find(client_ids).collect{|user| user.login}.to_sentence
    private_chat_room_id = 'private_chat_room_'+client_ids.join('_')
    private_chat_input_id = 'private_chat_input_'+client_ids.join('_')
    
    top ="<div class='private_message'><h3>#{users}</h3><div id='#{private_chat_room_id}' class='private_chat_room scroller'></div><div id='chat_form'>"
    
    form = form_remote_tag(:url => { :action => :send_private_message, :client_ids => client_ids }, :complete => "$('#{private_chat_input_id}').value = ''" )
    
    text = text_field_tag( private_chat_input_id, '', { :size => '50', :id => private_chat_input_id, :class=> 'private_chat_input'} )
    
    submit = submit_tag "Chat"
    
    bottom ="</form></div><div"
    
    top+form+text+submit+bottom
  end
end
