note
	description: "[
		Rosetta Code: Even or odd
		https://rosettacode.org/wiki/Even_or_odd

		Determine if a number is even or odd.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Even_or_odd"
	tier: "1"

class
	ODD_EVEN

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate even/odd detection.
		do
			print ("Even or Odd%N")
			print ("===========%N%N")

			across 0 |..| 10 as i loop
				print (i.out + " is " + (if is_even (i) then "even" else "odd" end) + "%N")
			end
		end

feature -- Query

	is_even (n: INTEGER): BOOLEAN
			-- Is n even?
		do
			Result := n \\ 2 = 0
		end

	is_odd (n: INTEGER): BOOLEAN
			-- Is n odd?
		do
			Result := n \\ 2 /= 0
		end

end