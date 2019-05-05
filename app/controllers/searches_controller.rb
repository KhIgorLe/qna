class SearchesController < ApplicationController
  skip_authorization_check

  def index
    @searched = Services::Search.search_by(params[:query], params[:type])
  end
end
