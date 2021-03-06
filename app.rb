require 'sinatra/base'
require './lib/peep.rb'
require './lib/user.rb'
require 'sinatra/flash'

class Chitter < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  
  before do
    if session[:username] 
      @user = User.find_by(username: session[:username])
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    User.create(
      username: params[:username], 
      password: params[:password]
    )
    
    redirect('/feed')
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    if User.authenticated?(
      username: params[:username], 
      password: params[:password]
    )
      session[:username] = params[:username]
      redirect('/feed')
    else
      flash[:notice] = 'Incorrect email or password'
      redirect('/login')
    end
  end
  
  get '/feed' do
    @peeps = Peep.order("created_at DESC").all
    erb :feed
  end

  post '/peep' do
    Peep.create({ content: params[:content] })
    redirect('/feed')
  end

  run! if app_file == $0
end
