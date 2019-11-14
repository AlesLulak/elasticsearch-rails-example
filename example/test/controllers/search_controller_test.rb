require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  # Elasticsearch use test-indexes
  setup do
    Person.__elasticsearch__.index_name = 'persons_test'
    Person.__elasticsearch__.import
    Comment.__elasticsearch__.index_name = 'comments_test'
    Comment.__elasticsearch__.import
  end

  test "get search without search data" do
    get :search
    assert_response :success
  end

  test "get search with search data" do
    get :search, { q: "just testing" }
    assert_response :success
  end

  test "get search with some comment data" do
    get :search, { q: "He" }
    assert_response :success
  end

  test "get search with some person data" do
    get :search, { q: "FirstMongo" }
    assert_response :success
  end
end
