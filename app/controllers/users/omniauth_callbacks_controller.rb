class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_github(request.env["omniauth.auth"])

    if @user
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Github')
      sign_in(:user, @user)
    else
      flash[:alert] = I18n.t('devise.omniauth_callbacks.failure', kind: 'Github', reason: 'something went wrong')
    end

    redirect_to root_path
  end

  def failure
    super
  end

  def after_omniauth_failure_path_for(scope)
    super(scope)
  end
end
