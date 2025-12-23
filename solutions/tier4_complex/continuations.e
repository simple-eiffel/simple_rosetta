note
	description: "[
		Rosetta Code: Continuations
		https://rosettacode.org/wiki/Continuations

		Implement continuation-passing style (CPS) programming.
		Eiffel doesn't have first-class continuations, but we can
		simulate CPS using agents as continuation functions.
	]"

class
	CONTINUATIONS

feature -- CPS Primitives

	cps_add (a, b: INTEGER; cont: PROCEDURE [INTEGER])
			-- Add in CPS style
		do
			cont.call ([a + b])
		end

	cps_multiply (a, b: INTEGER; cont: PROCEDURE [INTEGER])
			-- Multiply in CPS style
		do
			cont.call ([a * b])
		end

	cps_factorial (n: INTEGER; cont: PROCEDURE [INTEGER])
			-- Factorial in CPS style using helper
		do
			factorial_helper (n, 1, cont)
		end

	cps_fibonacci (n: INTEGER; cont: PROCEDURE [INTEGER])
			-- Fibonacci in CPS style using iterative approach
		local
			a, b, temp, i: INTEGER
		do
			if n <= 1 then
				cont.call ([n])
			else
				a := 0
				b := 1
				from i := 2 until i > n loop
					temp := a + b
					a := b
					b := temp
					i := i + 1
				end
				cont.call ([b])
			end
		end

feature {NONE} -- CPS Helpers

	factorial_helper (n, acc: INTEGER; cont: PROCEDURE [INTEGER])
			-- Tail-recursive factorial accumulator
		do
			if n <= 1 then
				cont.call ([acc])
			else
				factorial_helper (n - 1, n * acc, cont)
			end
		end

feature -- CPS Control Flow

	cps_if (condition: BOOLEAN; then_cont, else_cont: PROCEDURE)
			-- If-then-else in CPS
		do
			if condition then
				then_cont.call ([])
			else
				else_cont.call ([])
			end
		end

	cps_loop (init, limit: INTEGER; body: PROCEDURE [INTEGER]; done: PROCEDURE)
			-- Loop in CPS style
		do
			if init > limit then
				done.call ([])
			else
				body.call ([init])
				cps_loop (init + 1, limit, body, done)
			end
		end

feature -- Continuation-based Exception Handling

	safe_divide (a, b: INTEGER;
				success: PROCEDURE [INTEGER];
				failure: PROCEDURE [STRING])
			-- Division with error continuation
		do
			if b = 0 then
				failure.call (["Division by zero"])
			else
				success.call ([a // b])
			end
		end

feature -- Amb Operator (McCarthy's amb)

	amb_demo
			-- Demonstrate amb-style backtracking with continuations
		local
			x, y, z: INTEGER
		do
			print ("Pythagorean triples with sum 12:%N")
			-- Find pythagorean triples where x + y + z = 12
			from x := 1 until x > 12 loop
				from y := x until y > 12 loop
					from z := y until z > 12 loop
						if x + y + z = 12 and then x * x + y * y = z * z then
							print ("  " + x.out + "^2 + " + y.out + "^2 = " + z.out + "^2%N")
						end
						z := z + 1
					end
					y := y + 1
				end
				x := x + 1
			end
		end

feature -- Trampolined CPS (for deep recursion)

	trampoline_factorial (n: INTEGER): INTEGER
			-- Factorial using trampoline-style iteration (simulated)
		local
			acc, i: INTEGER
		do
			acc := 1
			from i := n until i <= 1 loop
				acc := acc * i
				i := i - 1
			end
			Result := acc
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			print_result: PROCEDURE [INTEGER]
		do
			print ("Continuations (CPS) Demo:%N%N")

			print_result := agent (r: INTEGER)
				do
					print ("  Result: " + r.out + "%N")
				end

			-- CPS arithmetic
			print ("CPS Arithmetic:%N")
			print ("  3 + 4 = ")
			cps_add (3, 4, print_result)

			print ("  5 * 6 = ")
			cps_multiply (5, 6, print_result)

			-- CPS factorial
			print ("%NCPS Factorial:%N")
			print ("  5! = ")
			cps_factorial (5, print_result)

			-- CPS fibonacci
			print ("%NCPS Fibonacci:%N")
			print ("  fib(10) = ")
			cps_fibonacci (10, print_result)

			-- CPS loop
			print ("%NCPS Loop (1 to 5):%N")
			cps_loop (1, 5,
				agent (i: INTEGER) do print ("  " + i.out + "%N") end,
				agent do print ("  Loop done%N") end)

			-- CPS exception handling
			print ("%NCPS Exception Handling:%N")
			print ("  10 / 2: ")
			safe_divide (10, 2,
				agent (r: INTEGER) do print (r.out + "%N") end,
				agent (err: STRING) do print ("Error: " + err + "%N") end)

			print ("  10 / 0: ")
			safe_divide (10, 0,
				agent (r: INTEGER) do print (r.out + "%N") end,
				agent (err: STRING) do print ("Error: " + err + "%N") end)

			-- Amb demo
			print ("%N")
			amb_demo

			-- Trampoline demo
			print ("%NTrampolined Factorial:%N")
			print ("  10! = " + trampoline_factorial (10).out + "%N")
		end

end
