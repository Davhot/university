# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  skip_before_action :check_app_auth, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:hot_catch_apps, notice: 'Вход выполнен')
    else
      flash[:danger] = "Неверный #{User.human_attribute_name(:email).mb_chars.downcase} или
#{User.human_attribute_name(:password).mb_chars.downcase}"
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: 'Сеанс работы в системе завершен'
  end

  def insufficient_privileges
    @current_user_object = current_user
    @current_user_login = @current_user_object.email
    @current_role_user = RoleUser.where(id: params['bad_user_role']).first
  end
end
