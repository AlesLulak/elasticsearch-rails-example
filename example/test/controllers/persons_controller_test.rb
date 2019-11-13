require "test_helper"

class PersonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should post index" do
    post :index
    assert_response :success
  end

  test "person should exclude on archvive action" do
    assert_difference "Person.excluded.count", 1 do
      patch :archive, { 'id': persons("p#{rand 10}".to_sym).id }
      assert_redirected_to controller: "persons", action: "index"
    end
  end

  # test "person edit should get" do
  #   get :edit, { 'id': persons("p#{rand 10}".to_sym).id }
  #   # needs mongo data

  #   assert_response :success   
  # end


  # test "person edit should contain delete button in other actions" do
  #   get :edit, { 'id': persons("p#{rand 10}".to_sym).id }

  #   assert_select ".card" do
  #     assert_select ".card-title", text: "Other actions"
  #     assert_select "[data-method=delete]"
  #   end
  # end

  # show doesnt exist!
  # test "person should get show" do
  #   get :show, { 'id': persons("p#{rand 10}".to_sym).id }
  #   assert_response :success
  # end

  # new
  test "person should get new" do
    get :new
    assert_response :success
  end  

  test "person new should get new instance of model" do
    get :new
    assert_kind_of Person, assigns(:person)
  end

  # create
  test "person create should post" do
    post :create, person: {firstname: "FirstTest", lastname: "LastTest"}
    assert_response :redirect
  end

  test "person create should be successful if missing name ___ not redirected" do
    post :create, person: {firstname: "", lastname: "LastTest"}
    assert_response :success
  end  

  # update
  test "person update should patch" do 
    patch :update, { 'id': persons("p#{rand 10}".to_sym).id, person: { firstname: "TestF", lastname: "TestL"} }
    assert_response :redirect
  end

  # destroy
  test "person delete should destroy" do
    delete :destroy, { 'id': persons("p#{rand 10}".to_sym).id }
    assert_response :redirect
  end  
  
end
