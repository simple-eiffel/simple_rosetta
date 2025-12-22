note
	description: "[
		Rosetta Code: ISBN13 check digit
		https://rosettacode.org/wiki/ISBN13_check_digit

		Validate and calculate ISBN-13 check digits.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "ISBN13_check_digit"
	tier: "2"

class
	ISBN13_CHECK

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate ISBN-13 validation.
		do
			print ("ISBN-13 Check Digit%N")
			print ("===================%N%N")

			test ("978-0596528126")
			test ("978-0596528127")
			test ("978-1-86197-876-9")
			test ("9780596528126")
			test ("9781234567890")
		end

feature -- Testing

	test (a_isbn: STRING)
			-- Test ISBN-13 validity.
		local
			l_clean: STRING
		do
			l_clean := clean_isbn (a_isbn)
			print ("ISBN: " + a_isbn + " -> ")
			if l_clean.count /= 13 then
				print ("Invalid length%N")
			elseif is_valid_isbn13 (l_clean) then
				print ("VALID%N")
			else
				print ("INVALID (should be: " + calculate_check_digit (l_clean.substring (1, 12)).out + ")%N")
			end
		end

feature -- Operations

	is_valid_isbn13 (a_isbn: STRING): BOOLEAN
			-- Is `a_isbn' a valid ISBN-13?
		require
			isbn_exists: a_isbn /= Void
			correct_length: clean_isbn (a_isbn).count = 13
		local
			l_sum, l_i: INTEGER
			l_digit: INTEGER
			l_clean: STRING
		do
			l_clean := clean_isbn (a_isbn)
			from l_i := 1 until l_i > 13 loop
				l_digit := (l_clean [l_i].code - ('0').code)
				if l_i \ 2 = 0 then
					l_sum := l_sum + l_digit * 3
				else
					l_sum := l_sum + l_digit
				end
				l_i := l_i + 1
			end
			Result := l_sum \ 10 = 0
		end

	calculate_check_digit (a_isbn12: STRING): INTEGER
			-- Calculate check digit for 12-digit ISBN prefix.
		require
			isbn_exists: a_isbn12 /= Void
			correct_length: clean_isbn (a_isbn12).count = 12
		local
			l_sum, l_i: INTEGER
			l_digit: INTEGER
			l_clean: STRING
		do
			l_clean := clean_isbn (a_isbn12)
			from l_i := 1 until l_i > 12 loop
				l_digit := (l_clean [l_i].code - ('0').code)
				if l_i \ 2 = 0 then
					l_sum := l_sum + l_digit * 3
				else
					l_sum := l_sum + l_digit
				end
				l_i := l_i + 1
			end
			Result := (10 - (l_sum \ 10)) \ 10
		ensure
			valid_digit: Result >= 0 and Result <= 9
		end

feature {NONE} -- Helpers

	clean_isbn (a_isbn: STRING): STRING
			-- Remove hyphens and spaces.
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (13)
			from l_i := 1 until l_i > a_isbn.count loop
				l_c := a_isbn [l_i]
				if l_c >= '0' and l_c <= '9' then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		end

end