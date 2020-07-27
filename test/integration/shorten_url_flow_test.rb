require 'test_helper'

class ShortenUrlFlowTest < Capybara::Rails::TestCase
  test 'can access root path' do
    visit root_path

    assert page.has_selector?('form[id=shorten-form]')
    assert page.has_selector?('input[name=long_url]')
    assert page.has_selector?('input[type=submit]')

    form_element = find('#shorten-form')
    form_node = form_element.native
    form_action = form_node.attributes['action']
    assert form_action.value == '/shorten'
  end

  test 'can shorten long url' do
    visit root_path

    long_url = 'https://www.google.com/search?source=hp&ei=vhUdX_fkKdj7wAOY3ZHYCw&q=lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit&oq=lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit&gs_lcp=CgZwc3ktYWIQDDIFCAAQzQIyBQgAEM0CUKIFWKIFYLcVaABwAHgAgAFTiAFTkgEBMZgBAKABAqABAaoBB2d3cy13aXo&sclient=psy-ab&ved=0ahUKEwj3u7PomOrqAhXYPXAKHZhuBLsQ4dUDCAs'
    fill_in 'long_url', with: long_url
    click_button 'submit'

    last_url = Url.last
    assert last_url.long_url == long_url
    assert current_path == "/shortened/#{last_url.id}"

    visit last_url.short_url
    assert current_path == '/search'
  end
end
