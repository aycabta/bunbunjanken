require 'bundler'
require 'sinatra'
require 'slim'
require 'twilio-ruby'

configure do
  set :root, File.dirname(__FILE__)
  set :static, true
  set :public_folder, "#{File.dirname(__FILE__)}/public"
  enable :run
  use Rack::Auth::Basic do |username, password|
    username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
  end
end

get '/' do
  slim :index
end

post '/yumewotukameyoutube' do
  client = Twilio::REST::Client.new ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']
  client.account.calls.create(
    :from => ENV['TWILIO_NUMBER'],
    :to => params[:to_number],
    # Fetch instructions from this URL when the call connects
    :url => 'http://bunbunjanken.herokuapp.com/bunbunjanken'
  )
  redirect "/", 302
end

bunbunjanken = proc do
  Twilio::TwiML::Response.new do |r|
    r.Play 'http://bunbunjanken.herokuapp.com/bunbunjanken.mp3'
  end.text
end

get('/bunbunjanken') { bunbunjanken.() }
post('/bunbunjanken') { bunbunjanken.() }

