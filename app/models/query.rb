# frozen_string_literal: true

require "net/http"

class Query
  def initialize(query, limit: 50, language: "en-US")
    @query = query
    @limit = limit
    @language = language
  end

  def search
    return [] unless @query.present?

    Rails.cache.fetch("search/#{@language}/#{@query}/#{@limit}", expires_in: 1.hour) do
      key = ENV["BING_KEY"]
      uri  = "https://api.bing.microsoft.com"
      path = "/v7.0/search"
      params = {
        q: @query,
        mkt: @language,
        count: @limit
      }
      uri = URI(uri + path + "?" + URI.encode_www_form(params))
      request = Net::HTTP::Get.new(uri)
      request["Ocp-Apim-Subscription-Key"] = key
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      json = JSON.parse(response.body)
      json["webPages"]["value"]
    end.map { |data| Result.new(data) }
  end
end
