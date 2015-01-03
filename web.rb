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

helpers do
  def protect!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    username = ENV['BASIC_AUTH_USERNAME']
    password = ENV['BASIC_AUTH_PASSWORD']
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
  end
end

before do
  uri = URI(request.url)
  if uri.path != '/bunbunjanken.mp3'
    protect!
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

