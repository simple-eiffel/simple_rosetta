note
	description: "[
		Rosetta Code: Verhoeff algorithm
		https://rosettacode.org/wiki/Verhoeff_algorithm

		Check digit algorithm using dihedral group D5.
		Detects all single-digit errors and most transpositions.
	]"

class
	VERHOEFF_ALGORITHM

feature -- Validation

	is_valid (number: STRING): BOOLEAN
			-- Does number pass Verhoeff checksum validation?
		require
			not_empty: not number.is_empty
			all_digits: across number as ch all ch >= '0' and ch <= '9' end
		local
			i, checksum, digit: INTEGER
			reversed: STRING
		do
			reversed := reverse_string (number)
			checksum := 0
			from i := 1 until i > reversed.count loop
				digit := reversed [i].code - ('0').code
				checksum := d_table [(checksum * 10) + permutation [((i - 1) \\ 8) * 10 + digit + 1] + 1]
				i := i + 1
			end
			Result := checksum = 0
		end

	compute_check_digit (number: STRING): CHARACTER
			-- Compute Verhoeff check digit
		require
			not_empty: not number.is_empty
			all_digits: across number as ch all ch >= '0' and ch <= '9' end
		local
			i, checksum, digit: INTEGER
			reversed: STRING
		do
			reversed := reverse_string (number)
			checksum := 0
			from i := 1 until i > reversed.count loop
				digit := reversed [i].code - ('0').code
				checksum := d_table [(checksum * 10) + permutation [(i \\ 8) * 10 + digit + 1] + 1]
				i := i + 1
			end
			Result := ('0').code.to_character_8 + inverse [checksum + 1]
		ensure
			is_digit: Result >= '0' and Result <= '9'
		end

	append_check_digit (number: STRING): STRING
			-- Return number with check digit appended
		require
			not_empty: not number.is_empty
			all_digits: across number as ch all ch >= '0' and ch <= '9' end
		do
			Result := number.twin
			Result.append_character (compute_check_digit (number))
		ensure
			one_longer: Result.count = number.count + 1
			valid_result: is_valid (Result)
		end

feature {NONE} -- Implementation

	reverse_string (s: STRING): STRING
			-- Reverse a string
		local
			i: INTEGER
		do
			create Result.make (s.count)
			from i := s.count until i < 1 loop
				Result.append_character (s [i])
				i := i - 1
			end
		end

	d_table: ARRAY [INTEGER]
			-- Multiplication table for D5 group
		once
			Result := <<
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
				1, 2, 3, 4, 0, 6, 7, 8, 9, 5,
				2, 3, 4, 0, 1, 7, 8, 9, 5, 6,
				3, 4, 0, 1, 2, 8, 9, 5, 6, 7,
				4, 0, 1, 2, 3, 9, 5, 6, 7, 8,
				5, 9, 8, 7, 6, 0, 4, 3, 2, 1,
				6, 5, 9, 8, 7, 1, 0, 4, 3, 2,
				7, 6, 5, 9, 8, 2, 1, 0, 4, 3,
				8, 7, 6, 5, 9, 3, 2, 1, 0, 4,
				9, 8, 7, 6, 5, 4, 3, 2, 1, 0
			>>
		end

	permutation: ARRAY [INTEGER]
			-- Permutation table
		once
			Result := <<
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
				1, 5, 7, 6, 2, 8, 3, 0, 9, 4,
				5, 8, 0, 3, 7, 9, 6, 1, 4, 2,
				8, 9, 1, 6, 0, 4, 3, 5, 2, 7,
				9, 4, 5, 3, 1, 2, 6, 8, 7, 0,
				4, 2, 8, 6, 5, 7, 3, 9, 0, 1,
				2, 7, 9, 3, 8, 0, 6, 4, 1, 5,
				7, 0, 4, 6, 9, 1, 3, 2, 5, 8
			>>
		end

	inverse: ARRAY [INTEGER]
			-- Inverse table
		once
			Result := <<0, 4, 3, 2, 1, 5, 6, 7, 8, 9>>
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			test_numbers: ARRAY [STRING]
			with_check: STRING
		do
			test_numbers := <<"236", "12345", "123451">>

			print ("Verhoeff Algorithm Demo:%N%N")

			across test_numbers as num loop
				print ("Number: " + num + "%N")
				print ("  Valid: " + is_valid (num).out + "%N")
				with_check := append_check_digit (num)
				print ("  With check digit: " + with_check + "%N")
				print ("  Validated: " + is_valid (with_check).out + "%N%N")
			end
		end

end
