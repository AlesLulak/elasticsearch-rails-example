class SearchController < ApplicationController
  def search
    def custom_query(q)
      query = {
        "query": {
          "bool": {
            "should": [
              {
                "bool": {
                  "must": [
                    {
                      "term": {
                        "excluded": false,
                      },
                    },
                    {
                      "multi_match": {
                        "query": q,
                        "fields": [
                          "firstname",
                          "lastname",
                          "emails.email",
                        ],
                      },
                    },
                  ],
                },
              },
              {
                "multi_match": {
                  "query": q,
                  "fields": [
                    "content",
                  ],
                },
              },
            ],
          },
        },
      }.as_json
    end

    @results = params[:q].nil? ? [] : Elasticsearch::Model.search(custom_query(params[:q]), [Person, Comment]).results.map { |r| [r._id, r._type] }

    respond_to do |format|
      format.html
      # format.json do
      #   render json: @persons.as_json(Person.index_json)
      # end
    end
  end
end
