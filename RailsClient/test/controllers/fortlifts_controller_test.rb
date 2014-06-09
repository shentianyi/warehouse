require 'test_helper'

class FortliftsControllerTest < ActionController::TestCase
  setup do
    @fortlift = fortlifts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fortlifts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fortlift" do
    assert_difference('Fortlift.count') do
      post :create, fortlift: {  }
    end

    assert_redirected_to fortlift_path(assigns(:fortlift))
  end

  test "should show fortlift" do
    get :show, id: @fortlift
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fortlift
    assert_response :success
  end

  test "should update fortlift" do
    patch :update, id: @fortlift, fortlift: {  }
    assert_redirected_to fortlift_path(assigns(:fortlift))
  end

  test "should destroy fortlift" do
    assert_difference('Fortlift.count', -1) do
      delete :destroy, id: @fortlift
    end

    assert_redirected_to fortlifts_path
  end
end
