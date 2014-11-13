require 'sinatra'
require 'pry'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Log
	include DataMapper::Resource
	property :id, Serial
	property :titre, String
	property :auteur, String
	property :contenu, Text
end

DataMapper.finalize
Log.auto_upgrade!

get '/' do
	@logs = Log.all(:order => [ :id.desc ])
	erb :index
end

get '/about' do
  erb :about
end

post '/new' do
	Log.create(:auteur => params[:auteur],:contenu => params[:log])
	redirect '/'
end

get '/delete/:id' do
	test = Log.get(params[:id])
	test.destroy
	redirect '/'
end

get '/edit/:id' do
	@log = Log.get(params[:id])
	erb :edit
end

post '/update/:id' do
	@log = Log.get(params[:id])
	@log.update(:auteur => params[:auteur],:contenu => params[:log])
	redirect '/'
end