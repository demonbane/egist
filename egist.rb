require 'rubygems'
require 'sinatra'
require 'json'
require 'net/https'
require './lib/pipefish'

get '/' do
  "Hello, world!"
end

get '/:gistid' do
  @gistid = params[:gistid]
  erb :decrypt
end

post '/decrypt' do
  abort "Invalid gist" unless params[:gistid]
  Pipefish.key=params[:password].to_s

  req = Net::HTTP::Get.new("/gists/#{params[:gistid]}")

  http = Net::HTTP.new("api.github.com", 443)
  http.use_ssl = true

  content = JSON.parse(http.request(req).body)["files"].values.last["content"]

  Pipefish.decrypt(content)
end
