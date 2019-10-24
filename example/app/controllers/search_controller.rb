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
                "match": {
                  "content": {
                    "query": q,
                    "boost": 1,
                  },
                },
              },
            ],
          },
        },
        "highlight": {
          "fields": {
            "content": {},
          },
        },
      }.as_json
    end

    @results = params[:q].nil? ? [] : Elasticsearch::Model.search(custom_query(params[:q]), [Person, Comment]).results.to_a.map { |r| { type: r._type, id: r._id.to_i, highlight: (!r["highlight"].nil? ? r["highlight"].content[0] : nil) } }

    respond_to do |format|
      format.html
      # format.json do
      #   render json: @persons.as_json(Person.index_json)
      # end
    end
  end
end
