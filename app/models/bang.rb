# frozen_string_literal: true

require "net/http"

BANGS = {
  "!" => nil,
  "!g" => "https://www.google.com/search?q=%s",
  "!w" => "https://en.wikipedia.org/wiki/Special:Search?search=%s"
}.freeze

class Bang
  attr_accessor :name, :url

  def initialize(query)
    words = query.split
    BANGS.each do |name, url|
      if words.delete(name)
        @name = name
        @url = url.sub("%s", URI.encode_www_form_component(words.join(" ")))
        break
      end
    end
  end

  def self.all
    BANGS
  end
end
