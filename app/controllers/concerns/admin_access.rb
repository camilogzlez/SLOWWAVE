module AdminAccess
  private

  def require_admin!
    authenticate_user!
    return if current_user.admin?

    redirect_to main_app.root_path, alert: "You are not allowed to access this page."
  end
end
