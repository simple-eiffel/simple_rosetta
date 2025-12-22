note
	description: "[
		Rosetta Code: Perfect numbers
		https://rosettacode.org/wiki/Perfect_numbers

		Find perfect numbers (equal to sum of proper divisors).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Perfect_numbers"
	tier: "2"

class
	PERFECT_NUMBERS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate perfect numbers.
		do
			print ("Perfect Numbers%N")
			print ("===============%N%N")

			print ("Perfect numbers up to 10000:%N")
			across 1 |..| 10000 as n loop
				if is_perfect (n) then
					print (n.out + " (divisors: " + divisors_string (n) + ")%N")
				end
			end
		end

feature -- Query

	is_perfect (n: INTEGER): BOOLEAN
			-- Is n a perfect number?
		require
			positive: n > 0
		do
			Result := sum_of_divisors (n) = n
		end

	sum_of_divisors (n: INTEGER): INTEGER
			-- Sum of proper divisors of n.
		require
			positive: n > 0
		local
			i: INTEGER
		do
			from i := 1 until i > n // 2 loop
				if n \\ i = 0 then
					Result := Result + i
				end
				i := i + 1
			end
		end

	divisors_string (n: INTEGER): STRING
			-- String of proper divisors.
		local
			i: INTEGER
		do
			create Result.make (50)
			from i := 1 until i > n // 2 loop
				if n \\ i = 0 then
					if not Result.is_empty then
						Result.append ("+")
					end
					Result.append (i.out)
				end
				i := i + 1
			end
		end

end