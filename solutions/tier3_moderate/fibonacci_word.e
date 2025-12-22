note
	description: "[
		Rosetta Code: Fibonacci word
		https://rosettacode.org/wiki/Fibonacci_word

		Generate Fibonacci words and calculate their entropy.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Fibonacci_word"
	tier: "3"

class
	FIBONACCI_WORD

create
	make

feature {NONE} -- Initialization

	make
			-- Generate Fibonacci words and show entropy.
		local
			l_prev, l_curr, l_next: STRING
			l_n: INTEGER
		do
			print ("Fibonacci Word%N")
			print ("N   Length          Entropy%N")
			print ("--- --------------- ---------%N")

			l_prev := "1"
			l_curr := "0"

			print_row (1, l_prev)
			print_row (2, l_curr)

			from l_n := 3 until l_n > 25 loop
				l_next := l_curr + l_prev
				print_row (l_n, l_next)
				l_prev := l_curr
				l_curr := l_next
				l_n := l_n + 1
			end
		end

feature -- Output

	print_row (a_n: INTEGER; a_word: STRING)
			-- Print row with number, length, and entropy.
		local
			l_ent: REAL_64
		do
			l_ent := entropy (a_word)
			print (a_n.out + spaces (4 - a_n.out.count))
			print (a_word.count.out + spaces (16 - a_word.count.out.count))
			print (format_real (l_ent) + "%N")
		end

feature -- Calculation

	entropy (a_str: STRING): REAL_64
			-- Calculate Shannon entropy of string.
		local
			l_count_0, l_count_1: INTEGER
			l_p0, l_p1: REAL_64
			l_log2: REAL_64
		do
			l_log2 := {DOUBLE_MATH}.log (2.0)

			across a_str as l_c loop
				if l_c = '0' then
					l_count_0 := l_count_0 + 1
				else
					l_count_1 := l_count_1 + 1
				end
			end

			if l_count_0 > 0 and l_count_1 > 0 then
				l_p0 := l_count_0 / a_str.count
				l_p1 := l_count_1 / a_str.count
				Result := -(l_p0 * log (l_p0) / l_log2 + l_p1 * log (l_p1) / l_log2)
			end
		end

	log (a_x: REAL_64): REAL_64
			-- Natural logarithm.
		external
			"C inline"
		alias
			"return log($a_x);"
		end

feature {NONE} -- Helpers

	spaces (a_n: INTEGER): STRING
			-- String of `a_n' spaces.
		do
			create Result.make_filled (' ', a_n.max (0))
		end

	format_real (a_val: REAL_64): STRING
			-- Format real to 9 decimal places.
		do
			Result := a_val.out
			if Result.count > 11 then
				Result := Result.substring (1, 11)
			end
		end

end
