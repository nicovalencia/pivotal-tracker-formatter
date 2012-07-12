require 'sinatra'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV['HTTP_USERNAME'], ENV['HTTP_PASSWORD']]
end

get '/' do
  erb :index
end
