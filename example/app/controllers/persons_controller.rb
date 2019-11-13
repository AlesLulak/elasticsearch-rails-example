class PersonsController < ApplicationController
  def index
    @persons = Person.includes(:emails).order(:firstname)
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

    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to persons_path, notice: "#{@person.firstname} was updated." }
      end
    end
  end
  
  def edit
    @person = Person.includes(emails: [:comments]).order("comments.created_at ASC").find(params[:id])
   
    @mongo_emails = {}
    @person.emails.each do |e|
      @mongo_emails[e.email] = EmailMongo.find_by(address: e.email).count
    end

    @email = @person.emails.new
  end

  def destroy
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.destroy
        format.html { redirect_to persons_path, notice: "#{@person.firstname} was deleted." }
      end
    end
  end

  # Custom actions

  # Include/exclude person from search list
  def archive
    @person = Person.find(params[:id])
    @person.excluded = !@person.excluded

    respond_to do |format|
      if @person.save
        format.html { redirect_to persons_path, notice: @person.excluded ? "#{@person.firstname} was excluded." : "#{@person.firstname} was included." }
      end
    end
  end

  private

  def person_params
    params.require(:person).permit(:firstname, :lastname)
  end
end
