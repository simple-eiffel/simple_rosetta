note
	description: "[
		Rosetta Code: Benford's law
		https://rosettacode.org/wiki/Benford%27s_law

		Benford's law predicts the frequency of leading digits in
		many real-world datasets. P(d) = log10(1 + 1/d).
		Test against Fibonacci numbers.
	]"

class
	BENFORDS_LAW

feature -- Constants

	expected_frequency (digit: INTEGER): REAL_64
			-- Benford's expected frequency for leading `digit`
		require
			valid_digit: digit >= 1 and digit <= 9
		do
			Result := log10 (1.0 + 1.0 / digit.to_double)
		ensure
			valid_range: Result > 0 and Result < 1
		end

feature -- Analysis

	leading_digit (n: INTEGER_64): INTEGER
			-- Leading (leftmost) digit of `n`
		require
			positive: n >= 1
		local
			remaining: INTEGER_64
		do
			from remaining := n until remaining < 10 loop
				remaining := remaining // 10
			end
			Result := remaining.to_integer_32
		ensure
			valid_digit: Result >= 1 and Result <= 9
		end

	digit_distribution (numbers: ARRAYED_LIST [INTEGER_64]): ARRAY [REAL_64]
			-- Frequency distribution of leading digits (index 1-9)
		require
			not_empty: not numbers.is_empty
		local
			counts: ARRAY [INTEGER]
			d, i: INTEGER
			total: INTEGER
		do
			create counts.make_filled (0, 1, 9)
			across numbers as n loop
				if n > 0 then
					d := leading_digit (n)
					counts [d] := counts [d] + 1
					total := total + 1
				end
			end

			create Result.make_filled (0.0, 1, 9)
			from i := 1 until i > 9 loop
				if total > 0 then
					Result [i] := counts [i].to_double / total.to_double
				end
				i := i + 1
			end
		ensure
			correct_size: Result.count = 9
		end

	chi_squared (observed, expected: ARRAY [REAL_64]; sample_size: INTEGER): REAL_64
			-- Chi-squared statistic comparing distributions
		require
			same_size: observed.count = expected.count
			positive_sample: sample_size > 0
		local
			i: INTEGER
			diff, exp_count: REAL_64
		do
			from i := 1 until i > observed.count loop
				exp_count := expected [i] * sample_size.to_double
				if exp_count > 0 then
					diff := (observed [i] * sample_size.to_double) - exp_count
					Result := Result + (diff * diff) / exp_count
				end
				i := i + 1
			end
		end

feature -- Fibonacci Test

	fibonacci_sequence (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- First `count` Fibonacci numbers
		require
			positive: count >= 1
		local
			i: INTEGER
			a, b, temp: INTEGER_64
		do
			create Result.make (count)
			a := 1
			b := 1
			Result.extend (a)
			if count > 1 then
				Result.extend (b)
			end
			from i := 3 until i > count loop
				temp := a + b
				a := b
				b := temp
				Result.extend (b)
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

feature {NONE} -- Implementation

	log10 (x: REAL_64): REAL_64
			-- Base-10 logarithm
		require
			positive: x > 0
		external
			"C inline use <math.h>"
		alias
			"return log10((double)$x);"
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			fibs: ARRAYED_LIST [INTEGER_64]
			observed, expected: ARRAY [REAL_64]
			i: INTEGER
		do
			fibs := fibonacci_sequence (1000)
			observed := digit_distribution (fibs)

			create expected.make_filled (0.0, 1, 9)
			from i := 1 until i > 9 loop
				expected [i] := expected_frequency (i)
				i := i + 1
			end

			print ("Benford's Law vs First 1000 Fibonacci Numbers:%N%N")
			print ("Digit  Expected   Observed   Difference%N")
			print ("-----  --------   --------   ----------%N")
			from i := 1 until i > 9 loop
				print (i.out + "      ")
				print (format_percent (expected [i]) + "     ")
				print (format_percent (observed [i]) + "     ")
				print (format_percent ((observed [i] - expected [i]).abs) + "%N")
				i := i + 1
			end
		end

	format_percent (r: REAL_64): STRING
			-- Format as percentage with 2 decimals
		local
			pct: REAL_64
		do
			pct := r * 100.0
			Result := pct.out
			if Result.count > 5 then
				Result := Result.substring (1, 5)
			end
			Result.append ("%%")
		end

end
