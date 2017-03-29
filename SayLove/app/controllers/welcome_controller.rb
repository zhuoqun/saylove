class WelcomeController < ApplicationController
  def index
    @page_id = 'welcome'

    render 'index', :layout => false
  end
end
