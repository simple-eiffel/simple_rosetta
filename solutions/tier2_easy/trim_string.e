note
	description: "[
		Rosetta Code: Strip whitespace from string
		https://rosettacode.org/wiki/Strip_whitespace_from_a_string/Top_and_tail

		Strip leading and trailing whitespace from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Strip_whitespace_from_a_string/Top_and_tail"
	tier: "2"

class
	TRIM_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate whitespace trimming.
		local
			l_str: STRING
		do
			print ("Strip Whitespace%N")
			print ("================%N%N")

			l_str := "   Hello, World!   "
			print ("Original: '" + l_str + "'%N")
			print ("Left trim: '" + trim_left (l_str) + "'%N")
			print ("Right trim: '" + trim_right (l_str) + "'%N")
			print ("Both trim: '" + trim (l_str) + "'%N%N")

			l_str := "%T%THello%T%T"
			print ("With tabs: '" + l_str + "'%N")
			print ("Trimmed: '" + trim (l_str) + "'%N")
		end

feature -- Operations

	trim (a_str: STRING): STRING
			-- Remove leading and trailing whitespace.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.left_adjust
			Result.right_adjust
		ensure
			result_exists: Result /= Void
		end

	trim_left (a_str: STRING): STRING
			-- Remove leading whitespace.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.left_adjust
		ensure
			result_exists: Result /= Void
		end

	trim_right (a_str: STRING): STRING
			-- Remove trailing whitespace.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.right_adjust
		ensure
			result_exists: Result /= Void
		end

end