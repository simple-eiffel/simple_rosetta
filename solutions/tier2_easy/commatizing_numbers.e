note
	description: "[
		Rosetta Code: Commatizing numbers
		https://rosettacode.org/wiki/Commatizing_numbers

		Add commas (or other separators) to numeric strings
		to make them more readable.
		Example: 1234567 -> 1,234,567
	]"

class
	COMMATIZING_NUMBERS

feature -- Formatting

	commatize (s: STRING): STRING
			-- Add commas to numeric string `s`
		require
			not_empty: not s.is_empty
		do
			Result := commatize_with (s, ',', 3)
		end

	commatize_with (s: STRING; separator: CHARACTER; group_size: INTEGER): STRING
			-- Add `separator` every `group_size` digits in `s`
		require
			not_empty: not s.is_empty
			valid_group: group_size >= 1
		local
			i, start_pos, end_pos: INTEGER
			sign: STRING
			num_part: STRING
		do
			-- Handle optional sign
			if s [1] = '-' or s [1] = '+' then
				sign := s.substring (1, 1)
				num_part := s.substring (2, s.count)
			else
				sign := ""
				num_part := s.twin
			end

			-- Find where digits end (before decimal point or end)
			end_pos := num_part.index_of ('.', 1)
			if end_pos = 0 then
				end_pos := num_part.count + 1
			end

			-- Find where digits start (skip leading non-digits)
			from start_pos := 1 until start_pos >= end_pos or num_part [start_pos].is_digit loop
				start_pos := start_pos + 1
			end

			-- Build result
			create Result.make (s.count + (end_pos - start_pos) // group_size)
			Result.append (sign)

			-- Add digits with separators
			from i := start_pos until i >= end_pos loop
				if i > start_pos and then (end_pos - i) \\ group_size = 0 then
					Result.append_character (separator)
				end
				Result.append_character (num_part [i])
				i := i + 1
			end

			-- Add remainder (decimal part if any)
			if end_pos <= num_part.count then
				Result.append (num_part.substring (end_pos, num_part.count))
			end
		end

	commatize_integer (n: INTEGER_64): STRING
			-- Commatize integer `n`
		do
			Result := commatize (n.out)
		end

	commatize_real (r: REAL_64; decimals: INTEGER): STRING
			-- Commatize real `r` with `decimals` decimal places
		require
			non_negative_decimals: decimals >= 0
		local
			fmt: FORMAT_DOUBLE
		do
			create fmt.make (20, decimals)
			fmt.no_justify
			Result := commatize (fmt.formatted (r))
			Result.left_adjust
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		do
			print ("Commatizing examples:%N")
			print ("  123456789    -> " + commatize ("123456789") + "%N")
			print ("  -123456789   -> " + commatize ("-123456789") + "%N")
			print ("  1234.5678    -> " + commatize ("1234.5678") + "%N")
			print ("  1234567.89   -> " + commatize ("1234567.89") + "%N")
			print ("%N")
			print ("With different separators:%N")
			print ("  1234567 (space, 3) -> " + commatize_with ("1234567", ' ', 3) + "%N")
			print ("  1234567 (dot, 3)   -> " + commatize_with ("1234567", '.', 3) + "%N")
			print ("  1234567890 (', 4)  -> " + commatize_with ("1234567890", ',', 4) + "%N")
		end

end
