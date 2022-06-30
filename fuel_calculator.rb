class FuelCalculator
  def initialize(flight_ship_mass, route)
    @flight_ship_mass = flight_ship_mass
    @route = route
  end

  def call
    result = whole_mass - @flight_ship_mass
    response(result)
  end

  private

  def whole_mass
    @route.reverse.inject(@flight_ship_mass) do |sum, (action, gravity)|
      method_name = "fuel_for_#{action}"
      sum + send(method_name, sum, gravity)
    end
  end

  def fuel_for_launch(mass, gravity)
    fuel = (mass*gravity*0.042-33).floor

    return 0 if fuel <= 0
    fuel + fuel_for_launch(fuel, gravity)
  end

  def fuel_for_land(mass, gravity)
    fuel = (mass*gravity*0.033-42).floor

    return 0 if fuel <= 0
    fuel + fuel_for_land(fuel, gravity)
  end

  def response(result)
    puts "Amount of fuel need: #{result} kg"
  end
end

service = FuelCalculator.new(28801,   [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]])
service.call

service = FuelCalculator.new(14606, [[:launch, 9.807], [:land, 3.711], [:launch, 3.711], [:land, 9.807]])
service.call

service = FuelCalculator.new(75432, [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 3.711], [:launch, 3.711], [:land, 9.807]])
service.call
