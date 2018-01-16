require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
<<<<<<< HEAD
      post :create, post: { content: @post.content, tag: @post.tag, title: @post.title, user_id: @post.user_id }
=======
      post :create, post: { content: @post.content, post_image: @post.post_image, tag: @post.tag, title: @post.title, user_id: @post.user_id }
>>>>>>> 30372491eaa60629d10e2933c66dd101223f9070
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
<<<<<<< HEAD
    patch :update, id: @post, post: { content: @post.content, tag: @post.tag, title: @post.title, user_id: @post.user_id }
=======
    patch :update, id: @post, post: { content: @post.content, post_image: @post.post_image, tag: @post.tag, title: @post.title, user_id: @post.user_id }
>>>>>>> 30372491eaa60629d10e2933c66dd101223f9070
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
