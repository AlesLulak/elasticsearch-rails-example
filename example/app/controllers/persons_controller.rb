class PersonsController < ApplicationController
  def index
    @persons = Person.order(:firstname)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to persons_path, notice: "Person was successfully added." }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @person = Person.find(params[:id])
    @person.excluded = !@person.excluded

    respond_to do |format|
      if @person.save
        format.html { redirect_to persons_path, notice: @person.excluded ? "#{@person.firstname} was excluded." : "#{@person.firstname} was included." }
      end
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  private

  def person_params
    params.require(:person).permit(:firstname, :lastname, :email)
  end
end
