note
	description: "[
		Rosetta Code: Memoization
		https://rosettacode.org/wiki/Memoization

		Cache function results to avoid redundant computation.
		Eiffel's 'once' feature provides built-in memoization.
	]"

class
	MEMOIZATION

feature -- Memoized Functions

	fibonacci (n: INTEGER): INTEGER
			-- Memoized fibonacci using hash table
		do
			if n <= 1 then
				Result := n
			elseif fib_cache.has (n) then
				Result := fib_cache [n]
			else
				Result := fibonacci (n - 1) + fibonacci (n - 2)
				fib_cache.force (Result, n)
			end
		end

	factorial (n: INTEGER): INTEGER
			-- Memoized factorial
		require
			non_negative: n >= 0
		do
			if n <= 1 then
				Result := 1
			elseif fact_cache.has (n) then
				Result := fact_cache [n]
			else
				Result := n * factorial (n - 1)
				fact_cache.force (Result, n)
			end
		end

feature {NONE} -- Caches

	fib_cache: HASH_TABLE [INTEGER, INTEGER]
			-- Fibonacci cache
		once
			create Result.make (100)
		end

	fact_cache: HASH_TABLE [INTEGER, INTEGER]
			-- Factorial cache
		once
			create Result.make (50)
		end

feature -- Generic Memoizer

	memoize (f: FUNCTION [INTEGER, INTEGER]): FUNCTION [INTEGER, INTEGER]
			-- Create memoized version of function
		local
			cache: HASH_TABLE [INTEGER, INTEGER]
		do
			create cache.make (100)
			Result := agent memoized_call (f, cache, ?)
		end

feature {NONE} -- Memoizer Helper

	memoized_call (f: FUNCTION [INTEGER, INTEGER]; cache: HASH_TABLE [INTEGER, INTEGER]; x: INTEGER): INTEGER
		do
			if cache.has (x) then
				Result := cache [x]
			else
				Result := f.item ([x])
				cache.force (Result, x)
			end
		end

feature -- Once Functions (Built-in Memoization)

	expensive_once: INTEGER
			-- Computed only once per program execution
		once
			print ("  [Computing expensive_once...]%N")
			Result := compute_expensive_value
		end

feature {NONE} -- Helper

	compute_expensive_value: INTEGER
		local
			i: INTEGER
		do
			-- Simulate expensive computation
			from i := 1 until i > 1000000 loop
				Result := Result + 1
				i := i + 1
			end
		end

feature -- Non-Memoized Comparison

	fibonacci_slow (n: INTEGER): INTEGER
			-- Non-memoized fibonacci (exponential)
		do
			if n <= 1 then
				Result := n
			else
				Result := fibonacci_slow (n - 1) + fibonacci_slow (n - 2)
			end
		end

feature -- Statistics

	cache_stats: STRING
			-- Show cache statistics
		do
			create Result.make (100)
			Result.append ("Fibonacci cache: " + fib_cache.count.out + " entries%N")
			Result.append ("Factorial cache: " + fact_cache.count.out + " entries%N")
		end

	clear_caches
			-- Clear all caches
		do
			fib_cache.wipe_out
			fact_cache.wipe_out
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			memoized_square: FUNCTION [INTEGER, INTEGER]
			call_count: CELL [INTEGER]
			counting_square: FUNCTION [INTEGER, INTEGER]
			i: INTEGER
		do
			print ("Memoization Demo:%N%N")

			-- Built-in once function
			print ("'once' function (built-in memoization):%N")
			print ("  First call: " + expensive_once.out + "%N")
			print ("  Second call: " + expensive_once.out + " (no recomputation)%N")

			-- Memoized fibonacci
			print ("%NMemoized Fibonacci:%N")
			clear_caches
			from i := 0 until i > 10 loop
				print ("  fib(" + i.out + ") = " + fibonacci (i).out + "%N")
				i := i + 1
			end
			print (cache_stats)

			-- Large fibonacci (only possible with memoization)
			print ("%NLarge Fibonacci (memoized):%N")
			print ("  fib(40) = " + fibonacci (40).out + "%N")
			print (cache_stats)

			-- Generic memoizer
			print ("%NGeneric memoizer:%N")
			create call_count.put (0)
			counting_square := agent (cc: CELL [INTEGER]; n: INTEGER): INTEGER
				do
					cc.put (cc.item + 1)
					Result := n * n
				end (call_count, ?)

			memoized_square := memoize (counting_square)

			print ("  Calling memoized_square(5) three times:%N")
			print ("    First: " + memoized_square.item ([5]).out + "%N")
			print ("    Second: " + memoized_square.item ([5]).out + "%N")
			print ("    Third: " + memoized_square.item ([5]).out + "%N")
			print ("  Actual computations: " + call_count.item.out + "%N")

			-- Factorial
			print ("%NMemoized Factorial:%N")
			from i := 1 until i > 10 loop
				print ("  " + i.out + "! = " + factorial (i).out + "%N")
				i := i + 1
			end
		end

end
