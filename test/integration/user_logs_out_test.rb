require "test_helper"

class UserLogsInWithTwitterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  def setup
    Capybara.app = Tinyposts::Application
    stub_omniauth
  end

  test "logging out" do
    visit "/"
    assert_equal 200, page.status_code
    within("body") do
      click_link "Log In"
    end
    assert_equal "/dashboard", current_path
    assert page.has_content?("mb")
    assert page.has_link?("Log Out")

    click_link "Log Out"
    assert_equal "/", current_path
    within("body") do
      assert page.has_content?("Log In")
    end
    refute page.has_content?("mb")
  end

  def stub_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: "1234",
      extra: {
        raw_info: {
          name: "MB",
          screen_name: "embee"
        }
      },
      credentials: {
        token: "pizza",
        secret: "secretpizza"
      }
    })
  end
end