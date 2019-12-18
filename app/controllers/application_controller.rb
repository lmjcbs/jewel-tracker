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
    erb :signup, locals: { user: User.new }
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/jewels"
    else
      redirect "/error"
    end
  end

  post "/signup" do
    user = User.create(params)
    if user.valid?
      session[:user_id] = user.id
      redirect "/jewels"
    else  
      erb :signup, locals: { user: user }
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

end
