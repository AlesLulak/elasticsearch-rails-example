class SearchController < ApplicationController
  def search
    @persons = params[:q].nil? ? [] : Person.find_by_fulltext(params[:q])

    byebug

    respond_to do |format|
      format.html
      format.json do
        render json: @persons.as_json(Person.index_json)
      end
    end
  end
end
