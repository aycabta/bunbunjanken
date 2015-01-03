require 'bundler'
require 'sinatra'
require 'slim'
require 'twilio-ruby'

configure do
  set :root, File.dirname(__FILE__)
  set :static, true
  set :public_folder, "#{File.dirname(__FILE__)}/public"
  enable :run
end

get '/' do
  slim :index
end


get '/bunbunjanken' do
  Twilio::TwiML::Response.new do |r|
    r.Say "Bunbun Janken hajimaruyo"
    r.Play 'http://bunbunjanken.herokuapp.com/bunbunjanken.mp3'
  end.text
end

