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

  def stats
    # email filter
    @email_icon = "fa-sort"
    @email_count_icon = "fa-sort"
    if params[:email]
      @emails = EmailMongo.has_some.order_by("address": params[:email])
      @email_icon = params[:email] == "asc" ? "fa-sort-up" : "fa-sort-down"
    elsif params[:email_count]
      @emails = EmailMongo.has_some.order_by("count": params[:email_count])
      @email_count_icon = params[:email_count] == "asc" ? "fa-sort-up" : "fa-sort-down"
    else
      @emails = EmailMongo.has_some
    end

    # domain filter
    @domain_icon = "fa-sort"
    @domain_count_icon = "fa-sort"
    if params[:domain_address]
      @domains = DomainMongo.has_some.order_by("domain": params[:domain_address])
      @domain_icon = params[:domain_address] == "asc" ? "fa-sort-up" : "fa-sort-down"
    elsif params[:domain_count]
      @domains = DomainMongo.has_some.order_by("count": params[:domain_count])
      @domain_count_icon = params[:domain_count] == "asc" ? "fa-sort-up" : "fa-sort-down"
    else
      @domains = DomainMongo.has_some
    end

    @sum = @domains.sum {|h| h[:count] }
  end

  def add_sent
    email_name = Email.find(params[:id]).email

    @email_mongo = EmailMongo.find_by(address: email_name)
    @domain_mongo = DomainMongo.find_by(domain: email_name.split('@')[1])

    @email_mongo.count += 1
    @domain_mongo.count += 1

    if @email_mongo.valid? && @domain_mongo.valid?
      @email_mongo.save
      @domain_mongo.save

      redirect_to edit_person_path(params[:person_id])
    end
  end
end
