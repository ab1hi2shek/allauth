class SessionsController < ActionController::Base

def create
	auth=request.env["omniauth.auth"]
	user=User.create_with_omniauth(auth)
	session[:user_id]=user.id
	value=User.f_o_c
		if value==2
			flash[:success]="Complete your Profile!!"
  			redirect_to edit_user_path(user)
		else
			flash[:success] = "welcome " + user.name + " !"
			redirect_to root_url
		end
end

def destroy
	reset_session
	flash[:success] = "Hope to see you soon !! "
	redirect_to root_url
end

def failure
redirect_to root_url, :alert => "Authentication error"
end

end
