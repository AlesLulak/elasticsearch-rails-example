require "test_helper"

class EmailsControllerTest < ActionController::TestCase
  # create
  test "email create should post" do
    post :create, { person_id: 1, email: { email: "email@email.com" } }
    assert_response :redirect
  end

  test "email fail create should redirect with notice" do
    post :create, { person_id: 1, email: { email: "" } }

    assert_response :redirect
  end

  test "email destroy" do
    delete :destroy, { person_id: 1, id: 1 }
    assert_response :redirect
  end

  # stats
  test "stats should get and show" do
    get :stats
    assert_response :success
  end

  test "stats should get and show with desc params" do
    get :stats, { email_count: "desc", domain_count: "desc" }
    assert_response :success
  end

  test "stats should get and show with asc params" do
    get :stats, { email_count: "asc", domain_count: "asc" }
    assert_response :success
  end

  test "stats should get and show with desc params email and domain" do
    get :stats, { email: "desc", domain_address: "desc" }
    assert_response :success
  end

  test "stats should get and show with asc params email and domain" do
    get :stats, { email: "asc", domain_address: "asc" }
    assert_response :success
  end

  #add sent
  test "add" do
    patch :add_sent, { id: 11, person_id: 11}
    assert :redirect
  end
end
