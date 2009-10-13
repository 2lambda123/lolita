class Admin::PublicUserController < ApplicationController

  private

  def login_public_user klass,login,password,options={}
    flash[:error]=nil
    if request.post? && params[:user]
      user = klass.authenticate(params[:user][login],params[:user][password])
      loged_in=yield user
      if user && loged_in
        register_user_in_session user
        remember_me user
        redirect_to options[:url] || home_url
      else
        flash[:error]||=I18n.t(:"flash.error.auth failed")
      end
    else
      redirect_to options[:url] || home_url if logged_in?
    end
  end

  def logout_public_user options={}
    if logged_in?
      self.current_user.forget_me
      reset_current_user
      flash[:success]||= I18n.t(:"flash.success.logout success")
    end
    redirect_to options[:url] || home_url
  end
  
  def remember_me(user)
    user.remember_me if !user.remember_token? && params[:user][:remember_user]
    cookies[:auth_token] = { :value => user.remember_token , :expires => user.remember_token_expires_at }
  end

  def reset_sso #lai varētu šeit ielik vēl ko ja vajadzēs
    Admin::Token.destroy_all(["user_id=? OR updated_at<?",current_user.id,1.day.ago]) if Lolita.config.system :multi_domain_portal && !is_local_request?
    cookies.delete(:sso_token)
  end
  
  def send_registration_email user,header,text
  #FIXME
  end
  
  def register_user_in_session user
    session.to_hash.delete(:user)
    set_current_user user
  end

  def redirect_authenticated_user
    if request.xml_http_request?
      render :text=>"[true]"
    else
      redirect_back_or_default(home_url) and return
    end
  end

  def redirect_user
    if request.xml_http_request?
      redirect_to home_url
    else
      redirect_to home_url
    end
  end

  
end
