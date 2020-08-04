require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  setup do
    @long_url = 'https://www.digitalocean.com/community/tutorials/how-to-benchmark-http-latency-with-wrk-on-ubuntu-14-04#step-3-%E2%80%94-install-wrk'
    @short_code = SecureRandom.urlsafe_base64 5
  end

  test 'valid url' do
    url = Url.new(long_url: @long_url, short_code: @short_code)
    assert url.valid?
  end

  test 'invalid without short_code' do
    url = Url.new(long_url: @long_url, short_code: nil)
    assert_not url.valid?
  end

  test 'invalid without long_url' do
    url = Url.new(long_url: nil, short_code: nil)
    assert_not url.valid?
  end

  test 'invalid with duplicate short code' do
    Url.create(long_url: @long_url, short_code: @short_code)
    url = Url.new(long_url: @long_url, short_code: @short_code)
    assert_not url.valid?
  end

  test 'generate_short_url with http' do
    url = Url.generate_short_url(@long_url)
    assert url.persisted?
    assert url.long_url == @long_url
  end

  test 'generate_short_url without http' do
    url = Url.generate_short_url('google.com')
    assert url.persisted?
    assert url.long_url == 'https://google.com'
  end

  test 'within_click_limit?' do
    url = urls(:url_with_limit)
    url_nil_max_click = urls(:url_with_expiry)
    assert url.within_click_limit?
    assert url_nil_max_click.within_click_limit?

    3.times { Visit.create(url: url) }
    assert_not url.within_click_limit?
  end

  test 'not_expired?' do
    url = urls(:url_with_expiry)
    url_nil_expiry = urls(:url_with_limit)
    assert url.not_expired?
    assert url_nil_expiry.not_expired?

    url.expiry_date = Date.yesterday
    assert_not url.not_expired?
  end

  test 'allow_redirect?' do
    url_expiry = urls(:url_with_expiry)
    url_limit = urls(:url_with_limit)
    assert url_expiry.allow_redirect?
    assert url_limit.allow_redirect?
  end

  test 'short_url' do
    url = Url.create(long_url: @long_url, short_code: @short_code)
    assert url.short_url == "#{ENV['RAILS_HOST']}/#{@short_code}"
  end

  test 'expiry_date_string' do
    url = Url.create(long_url: @long_url, short_code: @short_code, expiry_date: Date.current)
    assert url.expiry_date_string == Date.current.strftime('%m/%d/%Y')
  end

  test 'update_max_click_expiry' do
    params = {
      expiry_date: '12/31/2020',
      max_clicks: 10
    }
    url = Url.create(long_url: @long_url, short_code: @short_code)
    url.update_max_click_expiry(params)
    assert url.max_clicks == params[:max_clicks]
    assert url.expiry_date.strftime('%m/%d/%Y') == params[:expiry_date]
  end
end
