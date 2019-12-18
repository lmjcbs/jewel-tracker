class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "mysecret"
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
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/jewels"
    else
      redirect "/error"
    end
  end

  post "/signup" do
    user = User.new(username: params[:username], password: params[:password])
    if user.save #returns true/false. requires password field when signing up
      session[:user_id] = user.id
      redirect "/jewels"
    else
      redirect "/error"
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

end
