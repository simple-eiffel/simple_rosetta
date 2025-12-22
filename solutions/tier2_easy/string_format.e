note
	description: "[
		Rosetta Code: Formatted numeric output
		https://rosettacode.org/wiki/Formatted_numeric_output

		Format numbers as strings with various options.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Formatted_numeric_output"
	tier: "2"

class
	STRING_FORMAT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate numeric formatting.
		do
			print ("Formatted Numeric Output%N")
			print ("========================%N%N")

			print ("Integer formatting:%N")
			print ("  pad_left(42, 6): '" + pad_left (42.out, 6, ' ') + "'%N")
			print ("  pad_left(42, 6, '0'): '" + pad_left (42.out, 6, '0') + "'%N")
			print ("  pad_right(42, 6): '" + pad_right (42.out, 6, ' ') + "'%N")

			print ("%NReal formatting:%N")
			print ("  7.125: " + format_real (7.125, 2) + "%N")
			print ("  7.1: " + format_real (7.1, 2) + "%N")
			print ("  7.0: " + format_real (7.0, 2) + "%N")
		end

feature -- Formatting

	pad_left (a_str: STRING; a_width: INTEGER; a_pad: CHARACTER): STRING
			-- Pad string on left to width.
		require
			str_exists: a_str /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
		do
			l_padding := a_width - a_str.count
			if l_padding > 0 then
				create Result.make_filled (a_pad, l_padding)
				Result.append (a_str)
			else
				Result := a_str.twin
			end
		ensure
			result_exists: Result /= Void
			min_width: Result.count >= a_width
		end

	pad_right (a_str: STRING; a_width: INTEGER; a_pad: CHARACTER): STRING
			-- Pad string on right to width.
		require
			str_exists: a_str /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
		do
			Result := a_str.twin
			l_padding := a_width - a_str.count
			if l_padding > 0 then
				Result.append (create {STRING}.make_filled (a_pad, l_padding))
			end
		ensure
			result_exists: Result /= Void
			min_width: Result.count >= a_width
		end

	format_real (a_val: REAL_64; a_decimals: INTEGER): STRING
			-- Format real with specified decimal places.
		require
			non_negative_decimals: a_decimals >= 0
		local
			l_factor: REAL_64
			l_int: INTEGER_64
		do
			l_factor := (10 ^ a_decimals).truncated_to_real
			l_int := (a_val * l_factor + 0.5).truncated_to_integer_64
			Result := l_int.out
			if a_decimals > 0 then
				from until Result.count > a_decimals loop
					Result.prepend ("0")
				end
				Result.insert_character ('.', Result.count - a_decimals + 1)
			end
		ensure
			result_exists: Result /= Void
		end

end