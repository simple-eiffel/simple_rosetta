note
	description: "[
		Rosetta Code: Integer square root
		https://rosettacode.org/wiki/Integer_square_root
		
		Compute integer square root.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Integer_square_root"

class
	INTEGER_SQUARE_ROOT

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("isqrt(0) = " + isqrt (0).out + "%N")
			print ("isqrt(4) = " + isqrt (4).out + "%N")
			print ("isqrt(10) = " + isqrt (10).out + "%N")
			print ("isqrt(100) = " + isqrt (100).out + "%N")
			print ("isqrt(1000) = " + isqrt (1000).out + "%N")
		end

feature -- Computation

	isqrt (n: INTEGER_64): INTEGER_64
			-- Integer square root of `n' (floor of sqrt(n)).
		require
			non_negative: n >= 0
		local
			x, x1: INTEGER_64
		do
			if n = 0 then
				Result := 0
			else
				x := n
				x1 := (x + 1) // 2
				from until x1 >= x loop
					x := x1
					x1 := (x + n // x) // 2
				end
				Result := x
			end
		ensure
			valid_root: Result * Result <= n
			is_floor: (Result + 1) * (Result + 1) > n
		end

end
