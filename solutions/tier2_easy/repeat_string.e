note
	description: "[
		Rosetta Code: Repeat a string
		https://rosettacode.org/wiki/Repeat_a_string
		
		Repeat a string a specified number of times.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Repeat_a_string"

class
	REPEAT_STRING

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("'ha' * 5 = " + repeat ("ha", 5) + "%N")
			print ("'-' * 10 = " + repeat ("-", 10) + "%N")
			print ("'abc' * 3 = " + repeat ("abc", 3) + "%N")
		end

feature -- Operations

	repeat (s: STRING; n: INTEGER): STRING
			-- Return `s' repeated `n' times.
		require
			non_negative: n >= 0
		local
			i: INTEGER
		do
			create Result.make (s.count * n)
			from i := 1 until i > n loop
				Result.append (s)
				i := i + 1
			end
		ensure
			correct_length: Result.count = s.count * n
		end

end
