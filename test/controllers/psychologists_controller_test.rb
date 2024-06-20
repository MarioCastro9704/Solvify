require "test_helper"

class PsychologistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get psychologists_index_url
    assert_response :success
  end

  test "should get show" do
    get psychologists_show_url
    assert_response :success
  end

  test "should get new" do
    get psychologists_new_url
    assert_response :success
  end

  test "should get create" do
    get psychologists_create_url
    assert_response :success
  end

  test "should get edit" do
    get psychologists_edit_url
    assert_response :success
  end

  test "should get update" do
    get psychologists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get psychologists_destroy_url
    assert_response :success
  end
end
