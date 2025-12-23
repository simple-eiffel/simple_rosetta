note
	description: "[
		Rosetta Code: Farey sequence
		https://rosettacode.org/wiki/Farey_sequence

		The Farey sequence F_n is the sequence of reduced fractions
		between 0 and 1 with denominators <= n, in ascending order.
		F_5 = 0/1, 1/5, 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 1/1
	]"

class
	FAREY_SEQUENCE

feature -- Query

	farey (n: INTEGER): ARRAYED_LIST [TUPLE [num, denom: INTEGER]]
			-- Farey sequence F_n
		require
			positive: n >= 1
		local
			a, b, c, d, p, q: INTEGER
		do
			create Result.make (n * n)  -- Upper bound estimate
			-- Start with 0/1
			a := 0
			b := 1
			c := 1
			d := n
			Result.extend ([a, b])

			from until c > n loop
				-- Mediant property: next = (a+c)/(b+d) reduced
				p := (n + b) // d
				-- Next fraction
				a := p * c - a
				b := p * d - b
				-- Swap
				a := a + c
				c := a - c
				a := a - c
				b := b + d
				d := b - d
				b := b - d
				Result.extend ([a, b])
			end
		ensure
			starts_with_zero: Result.first.num = 0 and Result.first.denom = 1
			ends_with_one: Result.last.num = 1 and Result.last.denom = 1
		end

	farey_count (n: INTEGER): INTEGER
			-- Number of terms in Farey sequence F_n
			-- |F_n| = 1 + sum(phi(k) for k=1..n)
		require
			positive: n >= 1
		local
			k: INTEGER
		do
			Result := 1  -- For 0/1
			from k := 1 until k > n loop
				Result := Result + euler_phi (k)
				k := k + 1
			end
		end

feature -- Implementation

	euler_phi (n: INTEGER): INTEGER
			-- Euler's totient function
		require
			positive: n >= 1
		local
			result_val, p: INTEGER
			remaining: INTEGER
		do
			result_val := n
			remaining := n
			p := 2
			from until p * p > remaining loop
				if remaining \\ p = 0 then
					from until remaining \\ p /= 0 loop
						remaining := remaining // p
					end
					result_val := result_val - result_val // p
				end
				p := p + 1
			end
			if remaining > 1 then
				result_val := result_val - result_val // remaining
			end
			Result := result_val
		end

	gcd (a, b: INTEGER): INTEGER
			-- Greatest common divisor
		do
			if b = 0 then
				Result := a
			else
				Result := gcd (b, a \\ b)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			seq: ARRAYED_LIST [TUPLE [num, denom: INTEGER]]
			n: INTEGER
		do
			from n := 1 until n > 5 loop
				print ("F_" + n.out + ": ")
				seq := farey (n)
				print (farey_to_csv (seq))
				print ("%N")
				n := n + 1
			end

			print ("%NFarey sequence lengths:%N")
			from n := 100 until n > 1000 loop
				print ("|F_" + n.out + "| = " + farey_count (n).out + "%N")
				n := n + 100
			end
		end

	farey_to_csv (seq: ARRAYED_LIST [TUPLE [num, denom: INTEGER]]): STRING
			-- Convert farey sequence to comma-separated string
		local
			i: INTEGER
		do
			create Result.make (seq.count * 8)
			from i := 1 until i > seq.count loop
				Result.append (seq [i].num.out + "/" + seq [i].denom.out)
				if i < seq.count then
					Result.append (", ")
				end
				i := i + 1
			end
		end

end
