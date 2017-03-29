class LettersController < ApplicationController

  before_filter :require_login
  skip_before_filter :require_login, :only => [:index, :hot, :show]

  def index
    if session[:user_id].nil?
      @page_id = 'random'
    else
      @page_id = 'index'
    end

    @submenu = 'recent'

    @letters = Letter.recent_letters.paginate(:page => params[:page])
  end

  def hot
    if session[:user_id].nil?
      @page_id = 'random'
    else
      @page_id = 'index'
    end

    @submenu = 'hot'

    @letters = Letter.hot_letters.paginate(:page => params[:page])

    render 'index'
  end

  def echobox
    @page_id = 'echobox'

    current_user = User.find(session[:user_id])

    if current_user.from_provider
      @letters = Letter.echo_letters_by_user(current_user).paginate(:page => params[:page])

      # mark all as read
      Letter.echo_letters_by_user(current_user).update_all(:is_viewed => true)
    end
  end

  def sentbox
    @page_id = 'sentbox'

    current_user = User.find(session[:user_id])

    @letters = current_user.letters.order('created_at DESC').paginate(:page => params[:page])
  end

  def favorites
    @page_id = 'favorites'

    @letters = Letter.favorited_by_user_id(session[:user_id]).paginate(:page => params[:page])
  end

  def show
    @letter = Letter.find(params[:id])

    if session[:user_id].blank?
      if !(@letter.is_public)
        redirect_to root_path
      end
    else
      current_user = User.find(session[:user_id])
      if !(@letter.is_public || @letter.user_id.to_i == current_user.id ||
        (@letter.has_echo && @letter.contact_type == current_user.provider.provider && @letter.contact_id == current_user.provider.uid))

        redirect_to root_path
      end
    end

    @comments = @letter.comments.paginate(:page => params[:page])
  end

  def new

    @quote = Quote.offset(rand(Quote.count)).first

    @draft = cookies[session[:user_id]].blank? ? '' : cookies[session[:user_id]]

    render "new", :layout => false
  end

  def create
    @letter = Letter.new
    @letter.user_id = session[:user_id]
    @letter.contact_id = params[:userid]
    @letter.contact_type = params[:account_type]
    @letter.content = params[:content]

    @letter.content = '<p>' + @letter.content + '</p>'
    @letter.content = @letter.content.gsub(/\r\n/, '</p><p>')

    if (params[:public].present? && params[:public] == '1')
      @letter.is_public = true
    end

    if (params[:commentson].present? && params[:commentson] == '1')
      @letter.comments_on = true
    end

    respond_to do |format|
      if @letter.save
        format.html { render "create", :layout => "accounts" }
        format.json { render json: @letter, status: :created, location: @letter }
      else
        @letter.content = @letter.content.gsub(/<\/p><p>/, "\r\n")
        @letter.content = @letter.content.gsub(/<\/p>/, '')
        @letter.content = @letter.content.gsub(/<p>/, '')

        format.html { render action: "new" }
        format.json { render json: @letter.errors, status: :unprocessable_entity }
      end
    end

  end

  def favorite
    # add or delete favorite
    letter_id = params[:id]

    existed = Favorite.find_by_user_id_and_letter_id(session[:user_id], letter_id)
    action = ''

    if existed.present?
      # cancel favorite
      action = 'cancel'

      existed.destroy
    else
      # add favorite
      action = 'add'

      favorite = Favorite.new
      favorite.user_id = session[:user_id]
      favorite.letter_id = letter_id
      favorite.save
    end

    respond_to do |format|
      if 'cancel' == action
        format.json { render json: {:status => 0}, status: :ok}
      elsif 'add' == action
        format.json { render json: {:status => 0}, status: :created}
      end
    end

  end

  def flower
    # send flower
    letter_id = params[:id]

    existed = Flower.find_by_user_id_and_letter_id(session[:user_id], letter_id)
    action = ''

    if existed.present?
      # no change
      action = 'nochange'
    else
      # add favorite
      action = 'add'

      flower = Flower.new
      flower.user_id = session[:user_id]
      flower.letter_id = letter_id

      if flower.save
        add_notification(Letter.find(letter_id).user.id, letter_id, 'flower')
      end
    end

    respond_to do |format|
      if 'nochange' == action
        format.json { render json: {:status => -1}, status: :not_acceptable}
      elsif 'add' == action
        format.json { render json: {:status => 0, :count => Letter.find(letter_id).flowers.count}, status: :created}
      end
    end

  end

end
