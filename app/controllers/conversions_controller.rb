class ConversionsController < ApplicationController
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
    
    redirect_to conversions_path(result: @result, value: value, from_unit: from_unit, to_unit: to_unit)
  end

  private

  def convert(value, from_unit, to_unit)
    conversion_factors = {
      # Length
      'meters' => 1.0,
      'feet' => 3.28084,
      'inches' => 39.3701,
      'kilometers' => 0.001,
      'miles' => 0.000621371,
      
      # Weight
      'kilograms' => 1.0,
      'pounds' => 2.20462,
      'ounces' => 35.274,
      
      # Volume
      'liters' => 1.0,
      'gallons' => 0.264172,
      'cups' => 4.22675,
      'milliliters' => 1000.0
    }

    # Convert to base unit (meters for length, kilograms for weight, liters for volume)
    base_units = {
      'meters' => 'meters', 'feet' => 'meters', 'inches' => 'meters', 'kilometers' => 'meters', 'miles' => 'meters',
      'kilograms' => 'kilograms', 'pounds' => 'kilograms', 'ounces' => 'kilograms',
      'liters' => 'liters', 'gallons' => 'liters', 'cups' => 'liters', 'milliliters' => 'liters'
    }

    base_unit = base_units[from_unit]
    return 0 unless base_unit == base_units[to_unit] # Only convert between same type of measurements

    # Convert to base unit first
    base_value = if from_unit == base_unit
                   value
                 elsif from_unit == 'kilometers'
                   value * 1000
                 elsif from_unit == 'milliliters'
                   value / 1000
                 else
                   value / conversion_factors[from_unit]
                 end

    # Convert from base unit to target unit
    result = if to_unit == base_unit
               base_value
             elsif to_unit == 'kilometers'
               base_value / 1000
             elsif to_unit == 'milliliters'
               base_value * 1000
             else
               base_value * conversion_factors[to_unit]
             end

    result.round(4)
  end
end
