class Url < ApplicationRecord
  validates_uniqueness_of :short_code
  validates_presence_of :short_code, :long_url

  belongs_to :user, optional: true
  has_many :visits

  CODE_LENGTH = 5.freeze

  def generate_short_url
    return false if long_url.nil? || persisted?
    begin
      self.short_code = SecureRandom.urlsafe_base64 CODE_LENGTH
    end while Url.exists?(short_code: short_code)
    short_url
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
end
