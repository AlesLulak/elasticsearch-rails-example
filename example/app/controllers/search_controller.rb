class SearchController < ApplicationController
  def search
    @persons = params[:q].nil? ? [] : Person.find_by_fulltext(params[:q])
  end
end
