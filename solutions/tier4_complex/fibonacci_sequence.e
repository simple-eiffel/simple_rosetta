note
	description: "[
		Rosetta Code: Fibonacci sequence
		https://rosettacode.org/wiki/Fibonacci_sequence

		Generate Fibonacci numbers using multiple approaches.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Fibonacci_sequence"

class
	FIBONACCI_SEQUENCE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Fibonacci sequence generation.
		local
			i: INTEGER
		do
			print ("Fibonacci Sequence (first 20 numbers):%N")
			print ("=====================================%N%N")

			-- Iterative approach
			print ("Iterative: ")
			from i := 0 until i > 19 loop
				print (fib_iterative (i).out)
				if i < 19 then print (", ") end
				i := i + 1
			end
			print ("%N")

			-- Recursive approach (show first 15 only - slower)
			print ("Recursive: ")
			from i := 0 until i > 14 loop
				print (fib_recursive (i).out)
				if i < 14 then print (", ") end
				i := i + 1
			end
			print (", ...%N")

			-- Specific values
			print ("%NFib(30) = " + fib_iterative (30).out + "%N")
			print ("Fib(40) = " + fib_iterative (40).out + "%N")
		end

feature -- Fibonacci Calculations

	fib_iterative (n: INTEGER): INTEGER_64
			-- Fibonacci number at position n (iterative).
		require
			non_negative: n >= 0
		local
			a, b, temp: INTEGER_64
			i: INTEGER
		do
			if n <= 1 then
				Result := n.to_integer_64
			else
				a := 0
				b := 1
				from i := 2 until i > n loop
					temp := a + b
					a := b
					b := temp
					i := i + 1
				end
				Result := b
			end
		ensure
			non_negative_result: Result >= 0
		end

	fib_recursive (n: INTEGER): INTEGER_64
			-- Fibonacci number at position n (recursive).
			-- Note: Exponential time complexity - use for small n only.
		require
			non_negative: n >= 0
		do
			if n <= 1 then
				Result := n.to_integer_64
			else
				Result := fib_recursive (n - 1) + fib_recursive (n - 2)
			end
		ensure
			non_negative_result: Result >= 0
		end

	is_fibonacci (n: INTEGER_64): BOOLEAN
			-- Is n a Fibonacci number?
		local
			a, b, temp: INTEGER_64
		do
			if n < 0 then
				Result := False
			elseif n <= 1 then
				Result := True
			else
				from
					a := 0
					b := 1
				until
					b >= n
				loop
					temp := a + b
					a := b
					b := temp
				end
				Result := (b = n)
			end
		end

end
