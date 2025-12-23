note
	description: "[
		Rosetta Code: Fusc sequence
		https://rosettacode.org/wiki/Fusc_sequence

		The fusc function (Stern's diatomic series):
		fusc(0) = 0, fusc(1) = 1
		fusc(2n) = fusc(n)
		fusc(2n+1) = fusc(n) + fusc(n+1)
	]"

class
	FUSC_SEQUENCE

feature -- Query

	fusc (n: INTEGER): INTEGER
			-- n-th fusc number (Stern's diatomic series)
		require
			non_negative: n >= 0
		do
			if n = 0 then
				Result := 0
			elseif n = 1 then
				Result := 1
			elseif n \\ 2 = 0 then
				Result := fusc (n // 2)
			else
				Result := fusc (n // 2) + fusc (n // 2 + 1)
			end
		ensure
			non_negative: Result >= 0
		end

	fusc_iterative (n: INTEGER): INTEGER
			-- n-th fusc number using iteration (faster)
		require
			non_negative: n >= 0
		local
			a, b, m: INTEGER
		do
			if n = 0 then
				Result := 0
			else
				a := 1
				b := 0
				m := n
				from until m = 0 loop
					if m \\ 2 = 0 then
						a := a + b
					else
						b := a + b
					end
					m := m // 2
				end
				Result := b
			end
		end

	fusc_sequence (count: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `count` fusc numbers
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 0 until i >= count loop
				Result.extend (fusc_iterative (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	longest_fusc_below (limit: INTEGER): TUPLE [index, value: INTEGER]
			-- Index and value of largest fusc number with index < limit
		require
			positive: limit >= 1
		local
			i, max_val, max_idx, f: INTEGER
		do
			from i := 0 until i >= limit loop
				f := fusc_iterative (i)
				if f > max_val then
					max_val := f
					max_idx := i
				end
				i := i + 1
			end
			Result := [max_idx, max_val]
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			seq: ARRAYED_LIST [INTEGER]
			i: INTEGER
			max_info: TUPLE [index, value: INTEGER]
		do
			print ("First 61 fusc numbers (0-60):%N")
			seq := fusc_sequence (61)
			from i := 1 until i > seq.count loop
				print (seq [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N")

			print ("Largest fusc value with index < n:%N")
			from i := 1 until i > 7 loop
				max_info := longest_fusc_below ((10 ^ i).rounded.to_integer_32)
				print ("  n < 10^" + i.out + ": fusc(" + max_info.index.out + ") = " + max_info.value.out + "%N")
				i := i + 1
			end
		end

end
