require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    commande = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commandes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, commande: {  }
    end

    assert_redirected_to order_path(assigns(:commande))
  end

  test "should show order" do
    get :show, id: commande
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: commande
    assert_response :success
  end

  test "should update order" do
    patch :update, id: commande, commande: {  }
    assert_redirected_to order_path(assigns(:commande))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: commande
    end

    assert_redirected_to orders_path
  end
end
