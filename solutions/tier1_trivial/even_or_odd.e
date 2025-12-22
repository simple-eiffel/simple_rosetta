note
	description: "[
		Rosetta Code: Even or odd
		https://rosettacode.org/wiki/Even_or_odd
		
		Test whether an integer is even or odd.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Even_or_odd"

class
	EVEN_OR_ODD

create
	make

feature {NONE} -- Initialization

	make
		do
			test (0)
			test (1)
			test (2)
			test (-1)
			test (42)
			test (-17)
		end

feature -- Testing

	test (n: INTEGER)
		do
			if is_even (n) then
				print (n.out + " is even%N")
			else
				print (n.out + " is odd%N")
			end
		end

	is_even (n: INTEGER): BOOLEAN
			-- Is `n' an even number?
		do
			Result := n \\ 2 = 0
		ensure
			definition: Result = (n \\ 2 = 0)
		end

	is_odd (n: INTEGER): BOOLEAN
			-- Is `n' an odd number?
		do
			Result := n \\ 2 /= 0
		ensure
			opposite: Result = not is_even (n)
		end

end
