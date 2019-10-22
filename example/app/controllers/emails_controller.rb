class EmailsController < ApplicationController
  def create
    @person = Person.find(params[:person_id])
    @email = @person.emails.new(email: params[:email][:email])

    if @email.save
      redirect_to edit_person_path(@person), notice: "Email added to #{@person.firstname}."
    else
      redirect_to edit_person_path(@person), notice: "NOT ADDED: #{@email.errors.full_messages.last}"
    end
  end

  def destroy
    @person = Person.find(params[:person_id])
    @email = @person.emails.find(params[:id])

    if @email.destroy
      redirect_to edit_person_path(@person), notice: "Email #{@email.email} removed."
    end
  end
end
