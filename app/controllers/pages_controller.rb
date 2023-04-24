# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    #expires_in 5.minutes, public: true

    @title = "Search"
  end
end
