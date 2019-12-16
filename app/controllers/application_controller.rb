require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  get "/error" do
    erb :error
  end

  get "/signup" do
    erb :signup
  end

  post "/login" do
    user = User.find_by(username: params[:username])

    if !user.nil? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/jewels"
    else
      redirect "/error"
    end
  end

  post "/signup" do
    user = User.new(username: params["username"], password: params["password"])

    if user.save #requires password field when signing up
      redirect "/login"
    else
      redirect "/error"
    end
  end

end
