module ApplicationHelper

  include Rack::Utils
  alias_method :h, :escape_html

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['GMAIL_PSWD'], ENV['GMAIL_PSWD']]
  end
  
  def link_up(tweet)
    html_pass = tweet.gsub(/((http|https):?\/\/[\S]+)/, %Q{<a href='\\1' target='_blank'>\\1</a>})
    tag_pass = html_pass.gsub(/@([\w]+)/, %Q{<a href='https://twitter.com/#!/\\1'>@\\1</a>} )
  end

end