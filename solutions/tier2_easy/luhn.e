note
	description: "[
		Rosetta Code: Luhn test of credit card numbers
		https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers

		Validate credit card numbers using Luhn algorithm.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Luhn_test_of_credit_card_numbers"
	tier: "2"

class
	LUHN

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Luhn validation.
		do
			print ("Luhn Credit Card Validation%N")
			print ("===========================%N%N")

			test ("49927398716")
			test ("49927398717")
			test ("1234567812345678")
			test ("1234567812345670")
			test ("79927398713")
		end

feature -- Testing

	test (a_number: STRING)
			-- Test number validity.
		do
			print (a_number + " -> ")
			if is_valid (a_number) then
				print ("VALID%N")
			else
				print ("INVALID%N")
			end
		end

feature -- Validation

	is_valid (a_number: STRING): BOOLEAN
			-- Is `a_number' valid according to Luhn algorithm?
		require
			number_exists: a_number /= Void
		local
			l_sum, l_i, l_digit: INTEGER
			l_double: BOOLEAN
		do
			from l_i := a_number.count until l_i < 1 loop
				l_digit := a_number [l_i].code - ('0').code
				if l_double then
					l_digit := l_digit * 2
					if l_digit > 9 then
						l_digit := l_digit - 9
					end
				end
				l_sum := l_sum + l_digit
				l_double := not l_double
				l_i := l_i - 1
			end
			Result := l_sum \\ 10 = 0
		end

	calculate_check_digit (a_number: STRING): INTEGER
			-- Calculate Luhn check digit for number.
		require
			number_exists: a_number /= Void
		local
			l_sum, l_i, l_digit: INTEGER
			l_double: BOOLEAN
		do
			l_double := True
			from l_i := a_number.count until l_i < 1 loop
				l_digit := a_number [l_i].code - ('0').code
				if l_double then
					l_digit := l_digit * 2
					if l_digit > 9 then
						l_digit := l_digit - 9
					end
				end
				l_sum := l_sum + l_digit
				l_double := not l_double
				l_i := l_i - 1
			end
			Result := (10 - (l_sum \\ 10)) \\ 10
		ensure
			valid_digit: Result >= 0 and Result <= 9
		end

end