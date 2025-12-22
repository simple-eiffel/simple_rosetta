note
	description: "[
		Rosetta Code: Temperature conversion
		https://rosettacode.org/wiki/Temperature_conversion
		
		Convert between Celsius and Fahrenheit.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Temperature_conversion"

class
	TEMPERATURE_CONVERSION

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("Temperature Conversions:%N")
			print ("========================%N")
			print ("0°C = " + celsius_to_fahrenheit (0.0).out + "°F%N")
			print ("100°C = " + celsius_to_fahrenheit (100.0).out + "°F%N")
			print ("32°F = " + fahrenheit_to_celsius (32.0).out + "°C%N")
			print ("212°F = " + fahrenheit_to_celsius (212.0).out + "°C%N")
		end

feature -- Conversion

	celsius_to_fahrenheit (c: REAL_64): REAL_64
			-- Convert Celsius to Fahrenheit.
		do
			Result := c * 9.0 / 5.0 + 32.0
		ensure
			freezing_point: c = 0.0 implies Result = 32.0
			boiling_point: c = 100.0 implies (Result - 212.0).abs < 0.001
		end

	fahrenheit_to_celsius (f: REAL_64): REAL_64
			-- Convert Fahrenheit to Celsius.
		do
			Result := (f - 32.0) * 5.0 / 9.0
		ensure
			freezing_point: f = 32.0 implies Result = 0.0
		end

end
