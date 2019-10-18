class SearchController < ApplicationController
  def search
    @persons = params[:q].nil? ? [] : Person.find_by_fulltext(params[:q])
    respond_to do |format|
      format.html
      format.json { render json: @persons.as_json(only: [:firstname, :lastname, :email]) }
    end
  end
end
