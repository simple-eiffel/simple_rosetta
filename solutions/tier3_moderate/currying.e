note
	description: "[
		Rosetta Code: Currying
		https://rosettacode.org/wiki/Currying

		Transform functions with multiple arguments into chains of single-argument functions.
		Eiffel agents support partial application via open/closed arguments.
	]"

class
	CURRYING

feature -- Curried Functions

	curried_add: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]
			-- add(x)(y) = x + y
		do
			Result := agent add_partial (?)
		end

	curried_multiply: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]
			-- multiply(x)(y) = x * y
		do
			Result := agent multiply_partial (?)
		end

	curried_power: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]
			-- power(base)(exp) = base^exp
		do
			Result := agent power_partial (?)
		end

feature -- Three-argument currying

	curried_add3: FUNCTION [INTEGER, FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]]
			-- add3(x)(y)(z) = x + y + z
		do
			Result := agent add3_level1 (?)
		end

feature {NONE} -- Partial Application Helpers

	add_partial (x: INTEGER): FUNCTION [INTEGER, INTEGER]
		do
			Result := agent (a, b: INTEGER): INTEGER do Result := a + b end (x, ?)
		end

	multiply_partial (x: INTEGER): FUNCTION [INTEGER, INTEGER]
		do
			Result := agent (a, b: INTEGER): INTEGER do Result := a * b end (x, ?)
		end

	power_partial (base: INTEGER): FUNCTION [INTEGER, INTEGER]
		do
			Result := agent compute_power (base, ?)
		end

	compute_power (base, exp: INTEGER): INTEGER
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > exp loop
				Result := Result * base
				i := i + 1
			end
		end

	add3_level1 (x: INTEGER): FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]
		do
			Result := agent add3_level2 (x, ?)
		end

	add3_level2 (x, y: INTEGER): FUNCTION [INTEGER, INTEGER]
		do
			Result := agent (a, b, c: INTEGER): INTEGER do Result := a + b + c end (x, y, ?)
		end

feature -- Uncurrying

	uncurry_2 (f: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]): FUNCTION [INTEGER, INTEGER, INTEGER]
			-- Convert curried function to normal 2-argument function
		do
			Result := agent uncurried_call_2 (f, ?, ?)
		end

feature {NONE} -- Uncurrying Helper

	uncurried_call_2 (f: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]; x, y: INTEGER): INTEGER
		do
			Result := f.item ([x]).item ([y])
		end

feature -- Direct Partial Application (Eiffel style)

	make_adder (n: INTEGER): FUNCTION [INTEGER, INTEGER]
			-- Direct partial application using agent
		do
			Result := agent (fixed, x: INTEGER): INTEGER do Result := fixed + x end (n, ?)
		end

	make_multiplier (n: INTEGER): FUNCTION [INTEGER, INTEGER]
		do
			Result := agent (fixed, x: INTEGER): INTEGER do Result := fixed * x end (n, ?)
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			add, multiply, power: FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]
			add3: FUNCTION [INTEGER, FUNCTION [INTEGER, FUNCTION [INTEGER, INTEGER]]]
			add5, times7: FUNCTION [INTEGER, INTEGER]
			uncurried: FUNCTION [INTEGER, INTEGER, INTEGER]
		do
			print ("Currying Demo:%N%N")

			-- Two-argument currying
			add := curried_add
			multiply := curried_multiply
			power := curried_power

			print ("Curried functions:%N")
			print ("  add(3)(4) = " + add.item ([3]).item ([4]).out + "%N")
			print ("  multiply(6)(7) = " + multiply.item ([6]).item ([7]).out + "%N")
			print ("  power(2)(10) = " + power.item ([2]).item ([10]).out + "%N")

			-- Partial application
			print ("%NPartial application:%N")
			add5 := add.item ([5])
			times7 := multiply.item ([7])
			print ("  add5 = add(5)%N")
			print ("  add5(10) = " + add5.item ([10]).out + "%N")
			print ("  times7 = multiply(7)%N")
			print ("  times7(8) = " + times7.item ([8]).out + "%N")

			-- Three-argument currying
			print ("%NThree-argument currying:%N")
			add3 := curried_add3
			print ("  add3(1)(2)(3) = " + add3.item ([1]).item ([2]).item ([3]).out + "%N")

			-- Uncurrying
			print ("%NUncurrying:%N")
			uncurried := uncurry_2 (add)
			print ("  uncurried_add(3, 4) = " + uncurried.item ([3, 4]).out + "%N")

			-- Direct Eiffel partial application
			print ("%NDirect partial application (Eiffel agents):%N")
			add5 := make_adder (5)
			times7 := make_multiplier (7)
			print ("  make_adder(5)(100) = " + add5.item ([100]).out + "%N")
			print ("  make_multiplier(7)(11) = " + times7.item ([11]).out + "%N")
		end

end
