class AccountsController < ApplicationController

  require 'open-uri'

  before_filter :require_login, :only => [:search]

  def login
    @page_id = 'login'
    
    session[:return_to] = params[:url] if params[:url].present?
  end

  def faq
    @page_id = 'faq'

    render 'faq', :layout => 'profiles'
  end

  def settings
    @page_id = 'settings'

    @user = User.find(session[:user_id])

    render 'settings', :layout => 'profiles'
  end

  def settings_update
    @page_id = 'settings'

    email = params[:email]
    option_echo = params[:echo]
    option_flower = params[:flower]
    option_comment = params[:comment]

    @user = User.find(session[:user_id])

    if email.present?
      @user.email = email if @user.email != email
    elsif @user.email.blank?
      @user.email = 'can not be blank'
    end

    if option_echo.present?
      @user.email_option.echo = option_echo
    elsif @user.email_option.echo == true
      @user.email_option.echo = false
    end

    if option_flower.present?
      @user.email_option.flower = option_flower
    elsif @user.email_option.flower == true
      @user.email_option.flower = false
    end

    if option_comment.present?
      @user.email_option.comment = option_comment
    elsif @user.email_option.comment == true
      @user.email_option.comment = false
    end

    respond_to do |format|
      if @user.save && @user.email_option.save
        format.html { redirect_to settings_path, :notice => (t :save_success)}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'settings', :layout => 'profiles' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  def search
    # test if the user input is a valid sns user
    
    @user = User.find(session[:user_id])
    
    contact_type = params[:type]
    contact_name = params[:name]

    result = 'ok'
    user_id = ''

    if contact_type.present? && contact_name.present?
      case contact_type
      when 'douban'
        begin
          stream = open('http://api.douban.com/v2/user/' + contact_name +'?apikey=0e5122e5aaf4e3ec2af368b100deabc4')
          if (stream.status.first == '200')
            info = JSON.parse(stream.read)

            if info['id'].present?
              user_id = info['id']
            else
              result = 'not_exist'
            end
          else
            result = 'error'
          end
        rescue => e
          result = 'not_exist'
        end

      when 'weibo'
        begin
          stream = open('https://api.weibo.com/2/users/show.json?screen_name=' + URI.encode(contact_name) +'&source=911483792')

          if (stream.status.first == '200')
            info = JSON.parse(stream.read)

            if info['idstr'].present?
              user_id = info['idstr']
            else
              result = 'not_exist'
            end
          else
            result = 'error'
          end
        rescue => e
          result = 'not_exist'
        end

      end
    else
      result = 'error'
    end

    respond_to do |format|
      if 'ok' == result
        format.json { render json: {:status => 0, :id => user_id}, status: :ok}
      elsif 'not_exist' == result
        format.json { render json: {:status => -1} }
      elsif 'error' == result
        format.json { render json: {:status => -2} }
      end
    end

  end
end
