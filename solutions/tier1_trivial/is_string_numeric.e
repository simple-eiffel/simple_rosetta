note
	description: "[
		Rosetta Code: Determine if a string is numeric
		https://rosettacode.org/wiki/Determine_if_a_string_is_numeric
		
		Check if a string represents a valid number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Determine_if_a_string_is_numeric"

class
	IS_STRING_NUMERIC

create
	make

feature {NONE} -- Initialization

	make
		do
			test ("42")
			test ("-17")
			test ("3.14159")
			test ("1.2e10")
			test ("hello")
			test ("")
			test ("  123  ")
		end

feature -- Testing

	test (s: STRING)
		do
			print ("'" + s + "' is numeric: " + is_numeric (s).out + "%N")
		end

	is_numeric (s: STRING): BOOLEAN
			-- Is `s' a valid numeric string?
		local
			trimmed: STRING
		do
			trimmed := s.twin
			trimmed.adjust
			Result := trimmed.is_integer or trimmed.is_real
		end

end
