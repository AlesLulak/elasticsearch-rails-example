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
    @results = params[:q].nil? ? [] : Elasticsearch::Model.search(custom_query(params[:q]), [Person, Comment]).results

    # get all comments' ids for include
    comments_ids = []
    @results.to_a.each do |res|
      if res._type = "commnets"
        comments_ids << res._id.to_i
      end
    end

    comments = Comment.includes(email: [:person]).where(id: comments_ids).to_a

    @results = @results.map do |r|
      case r._type
      when "person"
        {
          type: r._type,
          id: r._id,
          name: "#{r._source.firstname} #{r._source.lastname}",
        }
      when "comment"
        {
          type: r._type,
          id: r._id,
          email: comments.find { |c| c.id == r._id.to_i }.email.email,
          email_id: comments.find { |c| c.id == r._id.to_i }.email.id,
          person: "#{comments.find { |c| c.id == r._id.to_i }.email.person.firstname} #{comments.find { |c| c.id == r._id.to_i }.email.person.lastname}",
          person_id: comments.find { |c| c.id == r._id.to_i }.email.person.id,
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
