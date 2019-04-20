require 'test_helper'

class MotorbikesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get motorbikes_index_url
    assert_response :success
  end

  test "should get new" do
    get motorbikes_new_url
    assert_response :success
  end

  test "should get create" do
    get motorbikes_create_url
    assert_response :success
  end

  test "should get listing" do
    get motorbikes_listing_url
    assert_response :success
  end

  test "should get pricing" do
    get motorbikes_pricing_url
    assert_response :success
  end

  test "should get description" do
    get motorbikes_description_url
    assert_response :success
  end

  test "should get photo_upload" do
    get motorbikes_photo_upload_url
    assert_response :success
  end

  test "should get location" do
    get motorbikes_location_url
    assert_response :success
  end

  test "should get update" do
    get motorbikes_update_url
    assert_response :success
  end

end
