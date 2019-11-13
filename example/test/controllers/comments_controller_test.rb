require "test_helper"

class CommentsControllerTest < ActionController::TestCase
  # create
  test "comment create should post" do
    post :create, { email_id:  emails("e1".to_sym).id, person_id:  persons("p1".to_sym).id, comment_id: comments("c1".to_sym).id, comment: { content: "Haha" } }
    assert_response :redirect
  end
  
end
