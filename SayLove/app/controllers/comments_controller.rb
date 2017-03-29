class CommentsController < ApplicationController

  before_filter :require_login

  def create
    letter_id = params[:letter_id]
    @comment = Comment.new
    @comment.user_id = session[:user_id]
    @comment.letter_id = letter_id
    @comment.content = params[:content]

    respond_to do |format|
      if @comment.save
        add_notification(Letter.find(letter_id).user.id, letter_id, 'comment')

        format.html { redirect_to letter_path(letter_id) + '#comments' }
      else
        format.html { redirect_to letter_path(letter_id) + '#comment_input' }
      end
    end
    
  end

end
