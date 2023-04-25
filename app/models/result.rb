# frozen_string_literal: true

require "net/http"

class Result
  attr_accessor :url, :date, :name, :body

  def initialize(data)
    @date = data["dateLastCrawled"]&.to_time
    @name = data["name"]
    @body = data["snippet"]
    @url = data["url"]
  end

  def domain
    @domain ||= URI.parse(@url).host
  end

  def blocked_by?(user)
    user.blocked_domains.include?(domain)
  end

  def self.sample(n)
    n.times.map do
      Result.new({
        "dateLastCrawled" => Faker::Time.between(from: 2.years.ago, to: DateTime.now).to_s,
        "name" => Faker::Lorem.words(number: 5).join(" ").capitalize,
        "snippet" => Faker::Lorem.words(number: 40).join(" ").capitalize + "...",
        "url" => Faker::Internet.url,
      })
    end
  end
end

