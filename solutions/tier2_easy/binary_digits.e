note
	description: "[
		Rosetta Code: Binary digits
		https://rosettacode.org/wiki/Binary_digits

		Convert an integer to a binary string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Binary_digits"

class
	BINARY_DIGITS

create
	make

feature {NONE} -- Initialization

	make
			-- Display integers in binary.
		do
			print ("Integer to binary:%N")
			print ("  5 -> " + to_binary (5) + "%N")
			print ("  50 -> " + to_binary (50) + "%N")
			print ("  9000 -> " + to_binary (9000) + "%N")
			print ("  0 -> " + to_binary (0) + "%N")
			print ("  255 -> " + to_binary (255) + "%N")
		end

feature -- Conversion

	to_binary (n: INTEGER): STRING
			-- Convert n to binary string.
		require
			non_negative: n >= 0
		local
			remaining: INTEGER
		do
			if n = 0 then
				Result := "0"
			else
				create Result.make_empty
				from remaining := n until remaining = 0 loop
					if remaining \\ 2 = 1 then
						Result.prepend_character ('1')
					else
						Result.prepend_character ('0')
					end
					remaining := remaining // 2
				end
			end
		ensure
			not_empty: not Result.is_empty
		end

end
