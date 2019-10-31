require "test_helper"

class PersonArchivingTest < ActionDispatch::IntegrationTest
  test "excluded person should be highlighted" do
    person = persons("p#{rand 10}".to_sym)

    get "/"
    assert_response :success

    assert_not person.excluded, "Default excluded is false"
    patch_via_redirect "/#{person.id}/archive/"
    assert_equal "/", path

    person.reload

    assert person.excluded, "Person should be excluded after archive action"
    assert_select ".bg-excluded" # basic test, if 'any' is excluded

    # Include back
    patch_via_redirect "/#{person.id}/archive/"
    assert_equal "/", path

    person.reload

    assert_not person.excluded, "Person should be back again after inclusion"
  end
end
