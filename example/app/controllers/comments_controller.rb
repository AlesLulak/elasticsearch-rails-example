class CommentsController < ApplicationController
  def new
  end

  def create
    @email = Email.find(params[:email_id])
    @comment = @email.comments.new(content: params[:comment][:content])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to edit_person_path(params[:person_id]), notice: "Comment was successfully added." }
      end
    end
  end
end
