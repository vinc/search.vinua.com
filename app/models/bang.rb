# frozen_string_literal: true

require "net/http"

class Bang
  def self.all
    {
      "!" => nil,
      "!g" => "https://www.google.com/search?q=%s",
      "!w" => "https://en.wikipedia.org/wiki/Special:Search?search=%s"
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
