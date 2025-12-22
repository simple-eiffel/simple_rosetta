note
	description: "[
		Rosetta Code: Repeat a string
		https://rosettacode.org/wiki/Repeat_a_string

		Repeat a string a specified number of times.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Repeat_a_string"
	tier: "2"

class
	REPEAT_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string repetition.
		do
			print ("Repeat a String%N")
			print ("===============%N%N")

			print ("'ha' x 5 = '" + repeat ("ha", 5) + "'%N")
			print ("'*' x 10 = '" + repeat ("*", 10) + "'%N")
			print ("'abc' x 0 = '" + repeat ("abc", 0) + "'%N")
			print ("'' x 5 = '" + repeat ("", 5) + "'%N")
		end

feature -- Operations

	repeat (a_str: STRING; a_count: INTEGER): STRING
			-- Repeat `a_str' `a_count' times.
		require
			str_exists: a_str /= Void
			non_negative: a_count >= 0
		local
			l_i: INTEGER
		do
			create Result.make (a_str.count * a_count)
			from l_i := 1 until l_i > a_count loop
				Result.append (a_str)
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = a_str.count * a_count
		end

	repeat_char (a_char: CHARACTER; a_count: INTEGER): STRING
			-- Repeat character `a_char' `a_count' times.
		require
			non_negative: a_count >= 0
		do
			create Result.make_filled (a_char, a_count)
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = a_count
		end

end