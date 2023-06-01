# frozen_string_literal: true

require "net/http"

class Query
  def initialize(query, language: nil)
    @query = query
    @language = language || "en-US"
  end

  def search
    return unless @query.present?

    return Result.sample(10) if ["lorem", "lorem ipsum"].include?(@query.downcase)

    Rails.cache.fetch("search/#{@language}/#{@query}", expires_in: 3.seconds) do
      search_brave
    end
  end

  private

  def search_bing
      key = ENV["BING_KEY"]
      uri = "https://api.bing.microsoft.com/v7.0/search"
      params = {
        q: @query,
        mkt: @language,
        count: 50
      }
      uri = URI(uri + "?" + URI.encode_www_form(params))
      request = Net::HTTP::Get.new(uri)
      request["Ocp-Apim-Subscription-Key"] = key
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      json = JSON.parse(response.body)
      json.dig("webPages", "value")&.map do |data|
        data["body"] = data.delete("snippet")
        data["date"] = data.delete("dateLastCrawled")
        Result.new(data)
      end
  end

  def search_brave
      key = ENV["BRAVE_KEY"]
      uri = "https://api.search.brave.com/res/v1/web/search"
      lang, country = @language&.split("-")
      params = {
        q: @query,
        lang: lang,
        country: country,
        text_decorations: false,
        result_filter: "web",
        count: 20
      }
      uri = URI(uri + "?" + URI.encode_www_form(params))
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      request["X-Subscription-Token"] = key
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      json = JSON.parse(response.body)
      json.dig("web", "results")&.map do |data|
        data["name"] = data.delete("title")
        data["body"] = data.delete("description")
        data["date"] = data.delete("age")
        Result.new(data)
      end
  end
end
