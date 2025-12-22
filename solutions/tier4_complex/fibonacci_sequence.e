note
	description: "[
		Rosetta Code: Fibonacci sequence
		https://rosettacode.org/wiki/Fibonacci_sequence

		Generate Fibonacci numbers using multiple approaches.

		Updated based on Eric Bezault's DbC feedback:
		- Use NATURAL_64 (Fibonacci numbers are never negative)
		- Add definition postconditions to prove correctness
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
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
				print (fib (i).out)
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
			print ("%NFib(30) = " + fib (30).out + "%N")
			print ("Fib(40) = " + fib (40).out + "%N")

			-- Demonstrate DbC
			print ("%NDesign by Contract validates correctness.%N")
		end

feature -- Fibonacci Calculations

	fib (n: INTEGER): NATURAL_64
			-- Fibonacci number at position n (iterative, efficient).
		require
			non_negative: n >= 0
		local
			a, b, temp: NATURAL_64
			i: INTEGER
		do
			if n <= 1 then
				Result := n.to_natural_64
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
			-- Definition: Fibonacci sequence is defined as:
			-- F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)
			base_case_0: n = 0 implies Result = 0
			base_case_1: n = 1 implies Result = 1
			definition: n >= 2 implies Result = fib (n - 1) + fib (n - 2)
		end

	fib_recursive (n: INTEGER): NATURAL_64
			-- Fibonacci number at position n (recursive).
			-- Note: Exponential time complexity - use for small n only.
			-- Demonstrates the mathematical definition directly.
		require
			non_negative: n >= 0
			reasonable_size: n <= 40  -- Prevent excessive recursion
		do
			if n <= 1 then
				Result := n.to_natural_64
			else
				Result := fib_recursive (n - 1) + fib_recursive (n - 2)
			end
		ensure
			-- The recursive version IS the definition
			base_case_0: n = 0 implies Result = 0
			base_case_1: n = 1 implies Result = 1
			definition: n >= 2 implies Result = fib_recursive (n - 1) + fib_recursive (n - 2)
		end

	is_fibonacci (n: INTEGER_64): BOOLEAN
			-- Is n a Fibonacci number?
		local
			a, b, temp: NATURAL_64
			un: NATURAL_64
		do
			if n < 0 then
				Result := False
			elseif n <= 1 then
				Result := True
			else
				un := n.to_natural_64
				from
					a := 0
					b := 1
				until
					b >= un
				loop
					temp := a + b
					a := b
					b := temp
				end
				Result := (b = un)
			end
		ensure
			-- A number is Fibonacci if it appears in the sequence
			negative_not_fib: n < 0 implies not Result
		end

end