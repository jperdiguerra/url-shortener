class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:admin_home]

  def home
  end

  def admin
    if current_user
      if current_user.admin
        @urls = Url.all.sort_by(&:created_at)
      else
        redirect_to '/user'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def admin_home
    @urls = Url.all.sort_by(&:created_at)
  end
end
