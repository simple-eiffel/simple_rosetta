note
	description: "[
		Rosetta Code: Count in string
		https://rosettacode.org/wiki/Count_in_string
		
		Count occurrences of a character in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Count_in_string"

class
	COUNT_IN_STRING

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("Count 'a' in 'banana': " + count_char ("banana", 'a').out + "%N")
			print ("Count 'l' in 'hello world': " + count_char ("hello world", 'l').out + "%N")
			print ("Count 'x' in 'hello': " + count_char ("hello", 'x').out + "%N")
		end

feature -- Counting

	count_char (s: STRING; c: CHARACTER): INTEGER
			-- Count occurrences of `c' in `s'.
		local
			i: INTEGER
		do
			from i := 1 until i > s.count loop
				if s.item (i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		ensure
			non_negative: Result >= 0
			at_most_length: Result <= s.count
		end

end
