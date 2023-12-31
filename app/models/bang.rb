# frozen_string_literal: true

require "net/http"

class Bang
  def self.all
    {
      "!" => nil,
      "!g" => "https://www.google.com/search?q=%s",
      "!m" => "https://www.google.com/maps/search/%s",
      "!w" => "https://en.wikipedia.org/wiki/Special:Search?search=%s",
      "!gh" => "https://github.com/search?q=%s",
      "!gi" => "https://google.com/search?tbm=isch&tbs=imgo:1&q=%s",
      "!so" => "https://stackoverflow.com/search?q=%s",
      "!yt" => "https://www.youtube.com/results?search_query=%s",
      "!wa" => "https://www.wolframalpha.com/input/?i=%s",
      "!gems" => "https://rubygems.org/search?query=%s",
      "!crates" => "https://crates.io/search?q=%s",
    }.freeze
  end

  attr_accessor :name, :url

  def initialize(query)
    words = query.split
    Bang.all.each do |name, url|
      if words.delete(name)
        @name = name
        @url = url&.sub("%s", URI.encode_www_form_component(words.join(" ")))
        break
      end
    end
  end
end
