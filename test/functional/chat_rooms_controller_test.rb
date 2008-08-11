require 'test_helper'

class ChatRoomsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:chat_rooms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_chat_room
    assert_difference('ChatRoom.count') do
      post :create, :chat_room => { }
    end

    assert_redirected_to chat_room_path(assigns(:chat_room))
  end

  def test_should_show_chat_room
    get :show, :id => chat_rooms(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => chat_rooms(:one).id
    assert_response :success
  end

  def test_should_update_chat_room
    put :update, :id => chat_rooms(:one).id, :chat_room => { }
    assert_redirected_to chat_room_path(assigns(:chat_room))
  end

  def test_should_destroy_chat_room
    assert_difference('ChatRoom.count', -1) do
      delete :destroy, :id => chat_rooms(:one).id
    end

    assert_redirected_to chat_rooms_path
  end
end
