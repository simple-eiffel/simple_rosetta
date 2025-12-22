note
	description: "[
		Rosetta Code: Absolute value
		https://rosettacode.org/wiki/Absolute_value

		Calculate absolute value of a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Absolute_value"
	tier: "1"

class
	ABSOLUTE_VALUE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate absolute value.
		do
			print ("Absolute Value%N")
			print ("==============%N%N")

			demo (42)
			demo (-42)
			demo (0)
			demo (-1)
		end

feature -- Demo

	demo (n: INTEGER)
		do
			print ("|" + n.out + "| = " + abs (n).out + "%N")
		end

feature -- Query

	abs (n: INTEGER): INTEGER
			-- Absolute value of n.
		do
			Result := n.abs
		ensure
			non_negative: Result >= 0
		end

	abs_real (n: REAL_64): REAL_64
			-- Absolute value of real.
		do
			Result := n.abs
		ensure
			non_negative: Result >= 0.0
		end

end