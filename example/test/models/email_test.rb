require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  test "should not save without any attributes" do
    email = Email.new
    assert_not email.save, "Shouldn't save without attributes"
  end

  test "should save with relevant attributes" do
    email = Email.new email: "email@email.com"
    assert email.save, "Shouldn't save without attributes"
  end
end
