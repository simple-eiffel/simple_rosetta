note
	description: "[
		Rosetta Code: Change e letters to i in a string
		https://rosettacode.org/wiki/Change_e_letters_to_i_in_a_string

		Replace all 'e' with 'i' in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Change_e_letters_to_i_in_a_string"
	tier: "2"

class
	CHANGE_E_TO_I

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate e to i replacement.
		do
			print ("Change e letters to i%N")
			print ("=====================%N%N")

			demo ("Rosetta Code")
			demo ("Eiffel")
			demo ("excellence")
			demo ("programming")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show replacement.
		do
			print ("'" + a_str + "' -> '" + e_to_i (a_str) + "'%N")
		end

feature -- Operations

	e_to_i (a_str: STRING): STRING
			-- Replace all 'e' with 'i' (both cases).
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			Result := a_str.twin
			from l_i := 1 until l_i > Result.count loop
				l_c := Result [l_i]
				if l_c = 'e' then
					Result [l_i] := 'i'
				elseif l_c = 'E' then
					Result [l_i] := 'I'
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_str.count
		end

	replace_char (a_str: STRING; a_old, a_new: CHARACTER): STRING
			-- Replace all occurrences of a_old with a_new.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
		do
			Result := a_str.twin
			from l_i := 1 until l_i > Result.count loop
				if Result [l_i] = a_old then
					Result [l_i] := a_new
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end