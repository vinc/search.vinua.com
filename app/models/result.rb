# frozen_string_literal: true

require "net/http"

class Result
  attr_accessor :url, :date, :name, :body

  def initialize(data)
    @date = Time.parse(data["dateLastCrawled"])
    @name = data["name"]
    @body = data["snippet"]
    @url = data["url"]
  end

  def host
    URI.parse(@url).host
  end
end

