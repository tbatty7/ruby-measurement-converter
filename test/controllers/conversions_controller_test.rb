require "test_helper"

class ConversionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get conversions_url
    assert_response :success
  end

  test "should convert length measurements" do
    # Test meters to feet
    post conversions_url, params: {
      value: "1.0",
      from_unit: "meters",
      to_unit: "feet"
    }
    assert_redirected_to conversions_path(result: "3.2808", value: "1.0", from_unit: "meters", to_unit: "feet")
    follow_redirect!
    assert_equal "3.2808", @controller.instance_variable_get(:@result)

    # Test kilometers to meters
    post conversions_url, params: {
      value: "1.0",
      from_unit: "kilometers",
      to_unit: "meters"
    }
    assert_redirected_to conversions_path(result: "1000.0000", value: "1.0", from_unit: "kilometers", to_unit: "meters")
    follow_redirect!
    assert_equal "1000.0000", @controller.instance_variable_get(:@result)

    # Test miles to kilometers
    post conversions_url, params: {
      value: "1.0",
      from_unit: "miles",
      to_unit: "kilometers"
    }
    assert_redirected_to conversions_path(result: "1.6093", value: "1.0", from_unit: "miles", to_unit: "kilometers")
    follow_redirect!
    assert_equal "1.6093", @controller.instance_variable_get(:@result)
  end

  test "should convert weight measurements" do
    # Test kilograms to pounds
    post conversions_url, params: {
      value: "1.0",
      from_unit: "kilograms",
      to_unit: "pounds"
    }
    assert_redirected_to conversions_path(result: "2.2046", value: "1.0", from_unit: "kilograms", to_unit: "pounds")
    follow_redirect!
    assert_equal "2.2046", @controller.instance_variable_get(:@result)

    # Test pounds to ounces
    post conversions_url, params: {
      value: "1.0",
      from_unit: "pounds",
      to_unit: "ounces"
    }
    assert_redirected_to conversions_path(result: "16.0000", value: "1.0", from_unit: "pounds", to_unit: "ounces")
    follow_redirect!
    assert_equal "16.0000", @controller.instance_variable_get(:@result)

    # Test grams to kilograms
    post conversions_url, params: {
      value: "1000.0",
      from_unit: "grams",
      to_unit: "kilograms"
    }
    assert_redirected_to conversions_path(result: "1.0000", value: "1000.0", from_unit: "grams", to_unit: "kilograms")
    follow_redirect!
    assert_equal "1.0000", @controller.instance_variable_get(:@result)
  end

  test "should convert volume measurements" do
    # Test liters to gallons
    post conversions_url, params: {
      value: "1.0",
      from_unit: "liters",
      to_unit: "gallons"
    }
    assert_redirected_to conversions_path(result: "0.2642", value: "1.0", from_unit: "liters", to_unit: "gallons")
    follow_redirect!
    assert_equal "0.2642", @controller.instance_variable_get(:@result)

    # Test milliliters to liters
    post conversions_url, params: {
      value: "1000.0",
      from_unit: "milliliters",
      to_unit: "liters"
    }
    assert_redirected_to conversions_path(result: "1.0000", value: "1000.0", from_unit: "milliliters", to_unit: "liters")
    follow_redirect!
    assert_equal "1.0000", @controller.instance_variable_get(:@result)

    # Test cups to liters
    post conversions_url, params: {
      value: "4.0",
      from_unit: "cups",
      to_unit: "liters"
    }
    assert_redirected_to conversions_path(result: "0.9464", value: "4.0", from_unit: "cups", to_unit: "liters")
    follow_redirect!
    assert_equal "0.9464", @controller.instance_variable_get(:@result)
  end

  test "should return 0 for incompatible units" do
    # Test length to weight conversion
    post conversions_url, params: {
      value: "1.0",
      from_unit: "meters",
      to_unit: "kilograms"
    }
    assert_redirected_to conversions_path(result: "0", value: "1.0", from_unit: "meters", to_unit: "kilograms")
    follow_redirect!
    assert_equal "0", @controller.instance_variable_get(:@result)

    # Test weight to volume conversion
    post conversions_url, params: {
      value: "1.0",
      from_unit: "kilograms",
      to_unit: "liters"
    }
    assert_redirected_to conversions_path(result: "0", value: "1.0", from_unit: "kilograms", to_unit: "liters")
    follow_redirect!
    assert_equal "0", @controller.instance_variable_get(:@result)
  end

  test "should handle decimal values" do
    # Test with decimal meters
    post conversions_url, params: {
      value: "1.5",
      from_unit: "meters",
      to_unit: "feet"
    }
    assert_redirected_to conversions_path(result: "4.9213", value: "1.5", from_unit: "meters", to_unit: "feet")
    follow_redirect!
    assert_equal "4.9213", @controller.instance_variable_get(:@result)

    # Test with decimal kilograms
    post conversions_url, params: {
      value: "2.5",
      from_unit: "kilograms",
      to_unit: "pounds"
    }
    assert_redirected_to conversions_path(result: "5.5116", value: "2.5", from_unit: "kilograms", to_unit: "pounds")
    follow_redirect!
    assert_equal "5.5116", @controller.instance_variable_get(:@result)
  end

  test "should preserve form values after conversion" do
    post conversions_url, params: {
      value: "1.0",
      from_unit: "meters",
      to_unit: "feet"
    }
    assert_redirected_to conversions_path(result: "3.2808", value: "1.0", from_unit: "meters", to_unit: "feet")
    follow_redirect!
    
    assert_equal "1.0", @controller.instance_variable_get(:@value)
    assert_equal "meters", @controller.instance_variable_get(:@from_unit)
    assert_equal "feet", @controller.instance_variable_get(:@to_unit)
  end

  test "should handle zero values" do
    post conversions_url, params: {
      value: "0.0",
      from_unit: "meters",
      to_unit: "feet"
    }
    assert_redirected_to conversions_path(result: "0", value: "0.0", from_unit: "meters", to_unit: "feet")
    follow_redirect!
    assert_equal "0", @controller.instance_variable_get(:@result)
  end

  test "should handle negative values" do
    post conversions_url, params: {
      value: "-1.0",
      from_unit: "meters",
      to_unit: "feet"
    }
    assert_redirected_to conversions_path(result: "-3.2808", value: "-1.0", from_unit: "meters", to_unit: "feet")
    follow_redirect!
    assert_equal "-3.2808", @controller.instance_variable_get(:@result)
  end

  test "should handle large values" do
    post conversions_url, params: {
      value: "1000000.0",
      from_unit: "milliliters",
      to_unit: "liters"
    }
    assert_redirected_to conversions_path(result: "1000.0000", value: "1000000.0", from_unit: "milliliters", to_unit: "liters")
    follow_redirect!
    assert_equal "1000.0000", @controller.instance_variable_get(:@result)
  end
end
