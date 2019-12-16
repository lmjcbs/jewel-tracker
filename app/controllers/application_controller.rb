require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  get "/signup" do
    erb :signup
  end

  post "/login" do
    @user = User.find_by(username: params[:username], password: params[:password])
    
    if @user.nil?
      erb :error
    else
      session[:user_id] = @user.id
      redirect '/jewels'
    end
  end

  post "/signup" do
    @user = User.new(username: params["username"], password: params["password"])

    if @user.save #requires password field when signing up
      redirect "/login"
    else
      redirect "/error"
    end
  end

end
