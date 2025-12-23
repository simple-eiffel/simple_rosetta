note
	description: "[
		Rosetta Code: De Bruijn sequences
		https://rosettacode.org/wiki/De_Bruijn_sequences

		A de Bruijn sequence B(k,n) is a cyclic sequence where every
		possible subsequence of length n appears exactly once.
		For k=2, n=4: sequence of length 16 containing all 4-bit patterns.
	]"

class
	DE_BRUIJN_SEQUENCES

feature -- Generation

	de_bruijn (alphabet: STRING; n: INTEGER): STRING
			-- Generate de Bruijn sequence B(k,n) for given alphabet
		require
			not_empty: not alphabet.is_empty
			positive_n: n >= 1
		local
			k: INTEGER
			a: ARRAY [INTEGER]
			sequence: ARRAYED_LIST [CHARACTER]
		do
			k := alphabet.count
			create a.make_filled (0, 0, k * n - 1)
			create sequence.make (power (k, n) + n - 1)

			generate_db (1, 1, k, n, a, alphabet, sequence)

			create Result.make (sequence.count)
			across sequence as c loop
				Result.append_character (c)
			end
		end

	de_bruijn_binary (n: INTEGER): STRING
			-- Generate binary de Bruijn sequence B(2,n)
		require
			positive: n >= 1
		do
			Result := de_bruijn ("01", n)
		ensure
			correct_length: Result.count = power (2, n)
		end

	power (base, exp: INTEGER): INTEGER
			-- base raised to exp
		require
			non_negative_exp: exp >= 0
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > exp loop
				Result := Result * base
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	generate_db (t, p, k, n: INTEGER; a: ARRAY [INTEGER]; alphabet: STRING; sequence: ARRAYED_LIST [CHARACTER])
			-- Martin's algorithm for de Bruijn sequence generation
		local
			j: INTEGER
		do
			if t > n then
				if n \\ p = 0 then
					from j := 1 until j > p loop
						sequence.extend (alphabet [a [j] + 1])
						j := j + 1
					end
				end
			else
				a [t] := a [t - p]
				generate_db (t + 1, p, k, n, a, alphabet, sequence)
				from j := a [t - p] + 1 until j >= k loop
					a [t] := j
					generate_db (t + 1, t, k, n, a, alphabet, sequence)
					j := j + 1
				end
			end
		end

feature -- Validation

	validate_de_bruijn (sequence: STRING; n: INTEGER): BOOLEAN
			-- Verify that sequence is a valid de Bruijn sequence for B(k,n)
		require
			not_empty: not sequence.is_empty
			valid_n: n >= 1
		local
			seen: HASH_TABLE [BOOLEAN, STRING]
			subseq: STRING
			i: INTEGER
			wrapped: STRING
		do
			create seen.make (sequence.count)
			wrapped := sequence + sequence.substring (1, n - 1)  -- Wrap around
			Result := True

			from i := 1 until i > sequence.count or not Result loop
				subseq := wrapped.substring (i, i + n - 1)
				if seen.has (subseq) then
					Result := False
				else
					seen.put (True, subseq)
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			seq: STRING
		do
			print ("De Bruijn sequence B(2,4) - all 4-bit patterns:%N")
			seq := de_bruijn_binary (4)
			print ("Sequence: " + seq + "%N")
			print ("Length: " + seq.count.out + "%N")
			print ("Valid: " + validate_de_bruijn (seq, 4).out + "%N")

			print ("%NDe Bruijn sequence B(10,3) - 3-digit PIN codes:%N")
			seq := de_bruijn ("0123456789", 3)
			print ("Length: " + seq.count.out + " (contains all 1000 3-digit codes)%N")
			print ("First 50 chars: " + seq.substring (1, (50).min (seq.count)) + "...%N")
			print ("Valid: " + validate_de_bruijn (seq, 3).out + "%N")
		end

end
