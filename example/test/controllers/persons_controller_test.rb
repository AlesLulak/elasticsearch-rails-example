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

  test "person edit should contain delete button in other actions" do
    get :edit, { 'id': persons("p#{rand 10}".to_sym).id }

    assert_select ".card" do
      assert_select ".card-title", text: "Other actions"
      assert_select "[data-method=delete]"
    end
  end
end
