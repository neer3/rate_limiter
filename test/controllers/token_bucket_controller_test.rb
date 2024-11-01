require "test_helper"

class TokenBucketControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get token_bucket_show_url
    assert_response :success
  end
end
