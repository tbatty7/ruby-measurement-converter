class ConversionsController < ApplicationController
  # Conversion factors relative to base units (meters, kilograms, liters)
  CONVERSION_FACTORS = {
    # Length (base unit: meters)
    'meters' => 1.0,
    'feet' => 3.28084,
    'inches' => 39.3701,
    'kilometers' => 0.001,
    'miles' => 0.000621371,
    
    # Weight (base unit: kilograms)
    'kilograms' => 1.0,
    'pounds' => 2.20462,
    'ounces' => 35.274,
    
    # Volume (base unit: liters)
    'liters' => 1.0,
    'gallons' => 0.264172,
    'cups' => 4.22675,
    'milliliters' => 1000.0
  }.freeze

  # Mapping of units to their base unit type
  BASE_UNITS = {
    # Length units
    'meters' => 'meters', 'feet' => 'meters', 'inches' => 'meters',
    'kilometers' => 'meters', 'miles' => 'meters',
    
    # Weight units
    'kilograms' => 'kilograms', 'pounds' => 'kilograms', 'ounces' => 'kilograms',
    
    # Volume units
    'liters' => 'liters', 'gallons' => 'liters', 'cups' => 'liters',
    'milliliters' => 'liters'
  }.freeze

  def index
    @result = params[:result]
    @from_unit = params[:from_unit]
    @to_unit = params[:to_unit]
    @value = params[:value]
  end

  def create
    value = params[:value].to_f
    from_unit = params[:from_unit]
    to_unit = params[:to_unit]
    
    @result = convert(value, from_unit, to_unit)
    
    redirect_to conversions_path(
      result: @result,
      value: value,
      from_unit: from_unit,
      to_unit: to_unit
    )
  end

  private

  # Converts a value from one unit to another
  def convert(value, from_unit, to_unit)
    return "0" unless compatible_units?(from_unit, to_unit)
    
    base_value = convert_to_base_unit(value, from_unit)
    result = convert_from_base_unit(base_value, to_unit)
    format_result(result)
  end

  # Checks if the units are compatible (same type of measurement)
  def compatible_units?(from_unit, to_unit)
    BASE_UNITS[from_unit] == BASE_UNITS[to_unit]
  end

  # Converts a value to its base unit (meters, kilograms, or liters)
  def convert_to_base_unit(value, unit)
    return value if unit == BASE_UNITS[unit]
    return value * 1000 if unit == 'kilometers'
    return value / 1000 if unit == 'milliliters'
    
    value / CONVERSION_FACTORS[unit]
  end

  # Converts a value from its base unit to the target unit
  def convert_from_base_unit(base_value, target_unit)
    return base_value if target_unit == BASE_UNITS[target_unit]
    return base_value / 1000 if target_unit == 'kilometers'
    return base_value * 1000 if target_unit == 'milliliters'
    
    base_value * CONVERSION_FACTORS[target_unit]
  end

  # Formats the result to 4 decimal places
  def format_result(value)
    return "0" if value.zero?
    "%.4f" % value
  end
end
