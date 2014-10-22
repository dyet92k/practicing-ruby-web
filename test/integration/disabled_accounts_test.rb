require_relative '../test_helper'

class DisabledAccountsTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)
  end

  test "can log in normally when account is not disabled" do
    sign_user_in
    visit articles_path

    assert_equal articles_path, current_path
  end

  test "gets rerouted to session problem page when logging into a disabled account" do
    @user.disable
    sign_user_in

    assert_equal problems_sessions_path, current_path
  end

  test "gets rerouted to problem page when disabled after sign-in" do
    sign_user_in
    @user.disable

    visit user_settings_path

    assert_equal problems_sessions_path, current_path
  end
end
