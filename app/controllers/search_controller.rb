class SearchController < ApplicationController
  def search
    @query = params[:q]
    @title = "Rezultaty wyszukiwania dla #{@query}"
    @results = PgSearch.multisearch(@query).page(params[:page]).per(15)
  end
end
