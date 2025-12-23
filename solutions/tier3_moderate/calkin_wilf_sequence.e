note
	description: "[
		Rosetta Code: Calkin-Wilf sequence
		https://rosettacode.org/wiki/Calkin-Wilf_sequence

		The Calkin-Wilf sequence enumerates all positive rationals.
		a(1) = 1/1, a(n+1) = 1/(2*floor(a(n))+1-a(n))
		Sequence: 1/1, 1/2, 2/1, 1/3, 3/2, 2/3, 3/1, 1/4, ...
	]"

class
	CALKIN_WILF_SEQUENCE

feature -- Query

	term_at (n: INTEGER): TUPLE [num, denom: INTEGER]
			-- n-th term of Calkin-Wilf sequence (1-indexed)
		require
			positive: n >= 1
		local
			i: INTEGER
			num, denom, floor_val, temp: INTEGER
		do
			num := 1
			denom := 1
			from i := 1 until i >= n loop
				floor_val := num // denom
				temp := denom
				denom := 2 * floor_val * denom + denom - num
				num := temp
				i := i + 1
			end
			Result := [num, denom]
		end

	sequence (count: INTEGER): ARRAYED_LIST [TUPLE [num, denom: INTEGER]]
			-- First `count` terms of Calkin-Wilf sequence
		require
			positive: count >= 1
		local
			i: INTEGER
			num, denom, floor_val, temp: INTEGER
		do
			create Result.make (count)
			num := 1
			denom := 1
			Result.extend ([num, denom])

			from i := 2 until i > count loop
				floor_val := num // denom
				temp := denom
				denom := 2 * floor_val * denom + denom - num
				num := temp
				Result.extend ([num, denom])
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	index_of (num, denom: INTEGER): INTEGER
			-- Index of fraction num/denom in Calkin-Wilf sequence
		require
			positive_num: num >= 1
			positive_denom: denom >= 1
			reduced: gcd (num, denom) = 1
		local
			n, d, bit: INTEGER
			bits: ARRAYED_LIST [INTEGER]
		do
			-- Convert to binary representation via continued fraction
			create bits.make (20)
			n := num
			d := denom
			from until n = 1 and d = 1 loop
				if n > d then
					bits.extend (1)
					n := n - d
				else
					bits.extend (0)
					d := d - n
				end
			end

			-- Convert bits to index
			Result := 1
			across bits as b loop
				Result := Result * 2 + b
			end
		end

feature -- Implementation

	gcd (a, b: INTEGER): INTEGER
			-- Greatest common divisor
		require
			positive: a >= 0 and b >= 0
		do
			if b = 0 then
				Result := a.max (1)
			else
				Result := gcd (b, a \\ b)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			seq: ARRAYED_LIST [TUPLE [num, denom: INTEGER]]
			t: TUPLE [num, denom: INTEGER]
			i: INTEGER
		do
			print ("First 20 terms of Calkin-Wilf sequence:%N")
			seq := sequence (20)
			from i := 1 until i > 20 loop
				t := seq [i]
				print (i.out + ": " + t.num.out + "/" + t.denom.out + "%N")
				i := i + 1
			end

			print ("%NIndex of 83/47 in sequence: " + index_of (83, 47).out + "%N")

			t := term_at (index_of (83, 47))
			print ("Verification - term at that index: " + t.num.out + "/" + t.denom.out + "%N")
		end

end
