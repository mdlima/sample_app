class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
                                 
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in( user, params[:session][:remember_me] == "1" )
      redirect_back_or user
    end
  end
  
  # def create
  #   auth = request.env['rack.auth']
  #   unless @auth = Authorization.find_from_hash(auth)
  #     # Create a new user or add an auth to existing user, depending on
  #     # whether there is already a user signed in.
  #     @auth = Authorization.create_from_hash(auth, current_user)
  #   end
  #   # Log the authorizing user in.
  #   self.current_user = @auth.user
  # 
  #   render :text => "Welcome, #{current_user.name}."
  # end

  def destroy
    sign_out
    redirect_to root_path
  end
end