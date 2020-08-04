class Url < ApplicationRecord
  validates_uniqueness_of :short_code
  validates_presence_of :short_code, :long_url

  belongs_to :user, optional: true
  has_many :visits

  CODE_LENGTH = 5.freeze

  def self.generate_short_url(long_url)
    return false if long_url.nil?
    url = Url.new
    url.long_url = add_http_protocol(long_url)
    begin
      short_code = SecureRandom.urlsafe_base64 CODE_LENGTH
    end while Url.exists?(short_code: short_code)
    url.short_code = short_code
    url.save
    url
  end

  def allow_redirect?
    within_click_limit? && not_expired?
  end

  def within_click_limit?
    max_clicks.nil? || max_clicks > visits.size
  end

  def not_expired?
    expiry_date.nil? || expiry_date >= Date.current
  end

  def short_url
    @short_url ||= "#{ENV['RAILS_HOST']}/#{short_code}"
  end

  def expiry_date_string
    expiry_date.present? ? expiry_date.strftime('%m/%d/%Y') : ''
  end

  def update_max_click_expiry(params)
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
    update_attributes(
      max_clicks: params[:max_clicks],
      expiry_date: date
    )
  end

  private

    def self.add_http_protocol(long_url)
      long_url[/\Ahttp(s)?:\/\//] ? long_url : "https://#{long_url}"
    end
end
