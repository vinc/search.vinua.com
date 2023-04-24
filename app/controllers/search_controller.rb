# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user.increment!(:queries_count)
    expires_in 5.minutes, public: true
    @query = search_params[:q].presence
    return redirect_to(root_path) if @query.blank?

    bang = Bang.new(@query)
    if bang.url.present?
      return redirect_to(bang.url, allow_other_host: true)
    end
    @title = [@query, "Search"].compact.join(" - ")
    @results = Query.new(@query, language: prefered_languages.first).search
    if bang.name == "!"
      res = @results.first
      return redirect_to(res.url, allow_other_host: true) if res
    end
  end

  private

  def prefered_languages
    http_accept_language.user_preferred_languages.select { |lang| lang["-"] }
  end

  def search_params
    params.permit(:q)
  end
end
