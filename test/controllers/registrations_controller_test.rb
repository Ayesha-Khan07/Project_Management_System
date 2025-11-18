require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new_ceo" do
    get registrations_new_ceo_url
    assert_response :success
  end

  test "should get create_ceo" do
    get registrations_create_ceo_url
    assert_response :success
  end
end
