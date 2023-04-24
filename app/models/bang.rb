# frozen_string_literal: true

require "net/http"

class Bang
  def self.all
    {
      "!" => nil,
      "!g" => "https://www.google.com/search?q=%s",
      "!w" => "https://en.wikipedia.org/wiki/Special:Search?search=%s",
      "!gi" => "https://google.com/search?tbm=isch&tbs=imgo:1&q=%s",
      "!so" => "https://stackoverflow.com/search?q=%s",
      "!yt" => "https://www.youtube.com/results?search_query=%s",
    }.freeze
  end

  attr_accessor :name, :url

  def initialize(query)
    words = query.split
    Bang.all.each do |name, url|
      if words.delete(name)
        @name = name
        @url = url.sub("%s", URI.encode_www_form_component(words.join(" ")))
        break
      end
    end
  end
end
