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
  param = params[:time]
  if human_format_with_timezone?(param)
    redirect thatz_url_for_human_format_with_timezone(param)
  elsif human_format_without_timezone?(param)
    erb :tz_detect
  elsif thatz_format?(param)
    @original_time = original_time_for_thatz_format(param)
    @times = all_times_for_thatz_format(param)
    haml :time
  else
    redirect "/cannot-parse/#{CGI.escape(param)}"
  end
end

get '/cannot-parse/:humanshit' do
  @input = params[:humanshit]
  haml :cannot_parse
end

get '/' do
  haml :index
end
