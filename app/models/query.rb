# frozen_string_literal: true

require "net/http"

class Query
  def initialize(query)
    @query = query
  end

  def search
    return [] unless @query.present?

    Rails.cache.fetch("search/#{@query}", expires_in: 1.hour) do
      key = ENV["BING_KEY"]
      uri  = "https://api.bing.microsoft.com"
      path = "/v7.0/search"
      uri = URI(uri + path + "?q=" + URI.encode_www_form_component(@query) + "&cc=US")
      request = Net::HTTP::Get.new(uri)
      request["Ocp-Apim-Subscription-Key"] = key
      request["Accept-Language"] = "en_US"
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      json = JSON.parse(response.body)
      json["webPages"]["value"]
    end.map { |data| Result.new(data) }
  end
end
