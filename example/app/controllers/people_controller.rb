class PeopleController < ApplicationController
  def index
    @persons = Person.all
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to people_path, notice: "Person was successfully added" }
      else
        format.html { render :new }
      end
    end
  end

  private

  def person_params
    params.require(:person).permit(:firstname, :lastname, :email)
  end
end
