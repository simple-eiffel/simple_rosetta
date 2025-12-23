note
	description: "[
		Rosetta Code: Damm algorithm
		https://rosettacode.org/wiki/Damm_algorithm

		Check digit algorithm that detects all single-digit errors
		and all adjacent transposition errors.
		Uses a quasigroup operation table.
	]"

class
	DAMM_ALGORITHM

feature -- Validation

	is_valid (number: STRING): BOOLEAN
			-- Does number pass Damm checksum validation?
		require
			not_empty: not number.is_empty
			all_digits: across number as c all c >= '0' and c <= '9' end
		do
			Result := compute_checksum (number) = 0
		end

	compute_check_digit (number: STRING): CHARACTER
			-- Compute check digit for number
		require
			not_empty: not number.is_empty
			all_digits: across number as c all c >= '0' and c <= '9' end
		do
			Result := ('0').code.to_character_8 + compute_checksum (number).to_integer_32
		ensure
			is_digit: Result >= '0' and Result <= '9'
		end

	append_check_digit (number: STRING): STRING
			-- Return number with check digit appended
		require
			not_empty: not number.is_empty
			all_digits: across number as c all c >= '0' and c <= '9' end
		do
			Result := number.twin
			Result.append_character (compute_check_digit (number))
		ensure
			one_longer: Result.count = number.count + 1
			valid_result: is_valid (Result)
		end

feature {NONE} -- Implementation

	compute_checksum (number: STRING): INTEGER
			-- Compute interim digit using quasigroup table
		local
			i, digit: INTEGER
		do
			Result := 0
			from i := 1 until i > number.count loop
				digit := number [i].code - ('0').code
				Result := quasigroup [Result * 10 + digit + 1]
				i := i + 1
			end
		end

	quasigroup: ARRAY [INTEGER]
			-- Damm quasigroup operation table (10x10)
		once
			Result := <<
				0, 3, 1, 7, 5, 9, 8, 6, 4, 2,
				7, 0, 9, 2, 1, 5, 4, 8, 6, 3,
				4, 2, 0, 6, 8, 7, 1, 3, 5, 9,
				1, 7, 5, 0, 9, 8, 3, 4, 2, 6,
				6, 1, 2, 3, 0, 4, 5, 9, 7, 8,
				3, 6, 7, 4, 2, 0, 9, 5, 8, 1,
				5, 8, 6, 9, 7, 2, 0, 1, 3, 4,
				8, 9, 4, 5, 3, 6, 2, 0, 1, 7,
				9, 4, 3, 8, 6, 1, 7, 2, 0, 5,
				2, 5, 8, 1, 4, 3, 6, 7, 9, 0
			>>
		ensure
			correct_size: Result.count = 100
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			test_numbers: ARRAY [STRING]
			with_check: STRING
		do
			test_numbers := <<"5724", "5727", "112946">>

			print ("Damm Algorithm Demo:%N%N")

			across test_numbers as num loop
				print ("Number: " + num + "%N")
				print ("  Valid: " + is_valid (num).out + "%N")
				with_check := append_check_digit (num)
				print ("  With check digit: " + with_check + "%N")
				print ("  Validated: " + is_valid (with_check).out + "%N%N")
			end
		end

end
