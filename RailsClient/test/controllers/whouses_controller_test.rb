require 'test_helper'

class WhousesControllerTest < ActionController::TestCase
  setup do
    @whouse = whouses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:whouses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create whouse" do
    assert_difference('Whouse.count') do
      post :create, whouse: {  }
    end

    assert_redirected_to whouse_path(assigns(:whouse))
  end

  test "should show whouse" do
    get :show, id: @whouse
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @whouse
    assert_response :success
  end

  test "should update whouse" do
    patch :update, id: @whouse, whouse: {  }
    assert_redirected_to whouse_path(assigns(:whouse))
  end

  test "should destroy whouse" do
    assert_difference('Whouse.count', -1) do
      delete :destroy, id: @whouse
    end

    assert_redirected_to whouses_path
  end
end
