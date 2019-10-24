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

    # Search and return relevant data in hash
    @results = params[:q].nil? ? [] : Elasticsearch::Model.search(custom_query(params[:q]), [Person, Comment]).results.map do |r|
      case r._type
      when "person"
        {
          type: r._type,
          id: r._id,
          name: "#{r._source.firstname} #{r._source.lastname}",
        }
      when "comment"
        # Needs parent data to be extracted from Postgresql
        comment = Comment.find(r._id)
        {
          type: r._type,
          id: r._id,
          email: comment.email.email,
          email_id: comment.email.id,
          person: "#{comment.email.person.firstname} #{comment.email.person.lastname}",
          person_id: comment.email.person.id,
          highlight: r["highlight"].content[0],
        }
      end
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @results.as_json(custom_query(params[:q]))
      end
    end
  end
end
