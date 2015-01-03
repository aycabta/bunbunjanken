require 'bundler'
require 'sinatra'
require 'slim'

configure do
  set :root, File.dirname(__FILE__)
  set :static, true
  set :public_folder, "#{File.dirname(__FILE__)}/public"
  enable :run
end

get '/' do
  slim :index
end

