module ApplicationHelper
  def time_ago(time)
    time_tag(time, time_ago_in_words(time), title: time)
  end
end
