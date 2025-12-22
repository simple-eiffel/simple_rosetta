note
	description: "[
		Rosetta Code: Determine if a string is numeric
		https://rosettacode.org/wiki/Determine_if_a_string_is_numeric

		Check if a string represents a valid number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_is_numeric"
	tier: "2"

class
	STRING_IS_NUMERIC

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate numeric detection.
		do
			print ("Is String Numeric?%N")
			print ("==================%N%N")

			test ("123")
			test ("-123")
			test ("123.45")
			test ("-123.45")
			test ("1e10")
			test ("1.5e-3")
			test ("abc")
			test ("12abc")
			test ("")
			test ("   42   ")
		end

feature -- Testing

	test (a_str: STRING)
			-- Test if string is numeric.
		do
			print ("'" + a_str + "' -> ")
			if is_integer (a_str) then
				print ("Integer%N")
			elseif is_real (a_str) then
				print ("Real%N")
			else
				print ("Not numeric%N")
			end
		end

feature -- Query

	is_integer (a_str: STRING): BOOLEAN
			-- Is `a_str' a valid integer?
		require
			str_exists: a_str /= Void
		local
			l_trimmed: STRING
		do
			l_trimmed := a_str.twin
			l_trimmed.left_adjust
			l_trimmed.right_adjust
			Result := l_trimmed.is_integer
		end

	is_real (a_str: STRING): BOOLEAN
			-- Is `a_str' a valid real number?
		require
			str_exists: a_str /= Void
		local
			l_trimmed: STRING
		do
			l_trimmed := a_str.twin
			l_trimmed.left_adjust
			l_trimmed.right_adjust
			Result := l_trimmed.is_double
		end

	is_numeric (a_str: STRING): BOOLEAN
			-- Is `a_str' any numeric value?
		require
			str_exists: a_str /= Void
		do
			Result := is_integer (a_str) or is_real (a_str)
		end

end