# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    expires_in 5.minutes, public: true

    @query = search_params[:q].presence

    return redirect_to(root_path) if @query.blank?

    @title = [@query, "Search"].compact.join(" - ")
    @results = Query.new(@query).search
  end

  private

  def search_params
    params.permit(:q)
  end
end
