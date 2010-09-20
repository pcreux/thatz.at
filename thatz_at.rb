require 'rubygems'
require 'sinatra'
require 'haml'
require 'cgi'
require File.join(File.dirname(__FILE__), 'lib/thatz_at.rb')

include ThatzAt

class TheTime
  def self.now
    Time.now
  end
end

get '/:time' do
  #param = CGI.unescape(params[:time])
  param = params[:time]
  if human_format_with_timezone?(param)
    redirect thatz_url_for_human_format_with_timezone(param)
  elsif human_format_without_timezone?(param)
    erb :tz_detect
  elsif thatz_format?(param)
    @original_time = original_time_for_thatz_format(param)
    @times = all_times_for_thatz_format(param)
    haml :index
  else
    "Don't know what to do with this url!"
  end
end

get '/cannot-parse/:humanshit' do
  "Cannot parse #{params[:humanshit]}"
end
