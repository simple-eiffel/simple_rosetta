note
	description: "[
		Rosetta Code: String multiplication
		https://rosettacode.org/wiki/String_multiplication

		Multiply a string by a factor.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_multiplication"
	tier: "2"

class
	STRING_MULTIPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string multiplication.
		do
			print ("String Multiplication%N")
			print ("=====================%N%N")

			demo ("Ha", 5)
			demo ("*-", 10)
			demo ("abc", 0)
			demo ("", 5)
		end

feature -- Demo

	demo (a_str: STRING; a_factor: INTEGER)
			-- Show multiplication.
		do
			print ("'" + a_str + "' * " + a_factor.out + " = '" + multiply (a_str, a_factor) + "'%N")
		end

feature -- Operations

	multiply (a_str: STRING; a_factor: INTEGER): STRING
			-- Repeat string a_factor times.
		require
			str_exists: a_str /= Void
			non_negative: a_factor >= 0
		local
			l_i: INTEGER
		do
			create Result.make (a_str.count * a_factor)
			from l_i := 1 until l_i > a_factor loop
				Result.append (a_str)
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = a_str.count * a_factor
		end

end