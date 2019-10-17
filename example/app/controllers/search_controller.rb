class SearchController < ApplicationController
  def search
    @persons = params[:q].nil? ? [] : Person.where("email like '%#{params[:q]}%' and excluded = 'false'")
  end
end
