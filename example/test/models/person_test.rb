require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "should not save without any attributes" do
    person = Person.new
    assert_not person.save, "Shouldn't save without attributes"
  end

  test "should not save without firstname" do
    person = Person.new lastname: persons("p#{rand 10}".to_sym).lastname
    assert_not person.save, "Could save person with lastname only"
  end

  test "should not save without lastname" do
    person = Person.new firstname: persons("p#{rand 10}".to_sym).firstname
    assert_not person.save, "Could save person with firstname only"
  end

  test "save person with both names" do
    person = Person.new firstname: persons("p#{rand 10}".to_sym).firstname, lastname: persons("p#{rand 10}".to_sym).lastname
    assert person.save, "Couldn't save the person even with both names"
  end

  test "destroy person just like that" do
    person = Person.find_by firstname: persons("p#{rand 10}".to_sym).firstname
    assert person.destroy, "Couldn't destroy the found person"
  end

  test "person fixture valid test" do
    person = persons("p#{rand 10}".to_sym)
    assert person.valid?
  end

  test "update person excluded to true" do
    person = Person.find_by firstname: persons("p#{rand 10}".to_sym).firstname
    assert person.update(excluded: true), "Couldn't set excluded to true"
  end

  test "update person excluded to false" do
    person = Person.find_by firstname: persons("p#{rand 10}".to_sym).firstname
    person.excluded = true
    assert person.update(excluded: false), "Couldn't set excluded to false"
  end

  test "fullname is correct" do
    person = Person.find_by firstname: persons("p#{rand 10}".to_sym).firstname
    assert_equal "#{person.firstname} #{person.lastname}", person.fullname
  end
end
