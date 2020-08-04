class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update]

  def index
    redirect_to root_path unless current_user.paid
    @urls = current_user.urls
  end

  def show
    @url = Url.find(params[:id])
  end

  def new
    @url = Url.new
  end

  def edit
    @url = Url.find(params[:id])
  end

  def create
    short_code = URI.escape(params[:short_code])
    @url = Url.new
    @url.short_code = short_code
    @url.long_url = params[:long_url]
    @url.user_id = current_user.id

    if @url.save
      redirect_to urls_path
    else
      render 'new'
    end
  end

  def update
    @url = Url.find(params[:id])

    if @url.update_max_click_expiry(params)
      redirect_to @url
    else
      render 'edit'
    end
  end

  def destroy
    url = Url.find_by(id: params[:id])
    url.try(:destroy)
    redirect_to admin_path
  end

  def shorten
    if params[:long_url].present?
      url = Url.generate_short_url(params[:long_url])
    end
    redirect_to url.try(:short_url).present? ? "/shortened/#{url.id}" : root_path
  end

  def shortened
    @url = Url.find_by(id: params[:id])
    redirect_to root_path unless @url
  end

  def redirect_link
    url = Url.find_by(short_code: params[:short_code])
    if url && url.allow_redirect?
      url.visits.create(ip_address: request.remote_ip, http_referrer: request.referer)
      redirect_to url.long_url
    else
      redirect_to expired_path
    end
  end

  private

    def create_params
      params.require(:url).permit(:short_code, :long_url)
    end
end
