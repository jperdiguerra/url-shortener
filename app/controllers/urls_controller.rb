class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update]

  # TODO: handle case when long_url is not long
  def shorten
    short_url = ''
    if params[:long_url].present?
      url = Url.new
      url.long_url = params[:long_url]
      short_url = url.generate_short_url
      url.save! if short_url
    end
    redirect_to short_url.present? ? "/shortened/#{url.id}" : root_path
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
      redirect_to '/expired'
    end
  end

  def index
    redirect_to root_path unless current_user.paid
    @user = current_user
    @urls = current_user.urls
  end

  def new
    @url = Url.new
  end

  def create
    short_code = URI.escape(params[:short_code])
    @url = Url.new
    @url.short_code = short_code
    @url.long_url = params[:long_url]
    @url.user_id = current_user.id

    if @url.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def edit
    @url = Url.find_by(id: params[:id])
  end

  def update
    url = Url.find_by(id: params[:id])
    resp = {}
    if url
      date =
        if params[:expiry_date].present?
          begin
            Date.strptime(params[:expiry_date],"%m/%d/%Y")
          rescue ArgumentError
            nil
          end
        else
          nil
        end
      url.update_attributes(
        max_clicks: params[:max_clicks],
        expiry_date: date
      )
      resp[:success] = true
    else
      resp[:success] = false
    end
    render json: resp
  end

  def delete
    url = Url.find_by(id: params[:id])
    url.try(:destroy)
    redirect_to '/admin'
  end
end
