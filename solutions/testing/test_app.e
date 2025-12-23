note
	description: "[
		Test application for Rosetta Code solutions.

		Runs all solution tests to verify correctness of implementations.
		Compatible with EiffelStudio Autotest tool.
	]"
	author: "Simple Eiffel"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run all solution tests.
		do
			print ("Running Rosetta Code Solution Tests%N")
			print ("====================================%N%N")
			passed := 0
			failed := 0

			run_tier1_tests
			run_tier2_tests
			run_tier3_tests
			run_tier4_tests
			run_cipher_tests

			print ("%N====================================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("SOME TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_tier1_tests
			-- Run Tier 1: Trivial tests.
		do
			print ("Tier 1: Trivial%N")
			print ("---------------%N")
			run_test (agent lib_tests.test_absolute_value, "test_absolute_value")
			run_test (agent lib_tests.test_even_or_odd, "test_even_or_odd")
			print ("%N")
		end

	run_tier2_tests
			-- Run Tier 2: Easy tests.
		do
			print ("Tier 2: Easy%N")
			print ("------------%N")
			-- String operations
			run_test (agent lib_tests.test_reverse_string, "test_reverse_string")
			run_test (agent lib_tests.test_caesar_cipher, "test_caesar_cipher")
			run_test (agent lib_tests.test_palindrome_detection, "test_palindrome_detection")
			run_test (agent lib_tests.test_rot13, "test_rot13")
			-- Numeric algorithms
			run_test (agent lib_tests.test_leap_year_check, "test_leap_year_check")
			run_test (agent lib_tests.test_prime_check, "test_prime_check")
			run_test (agent lib_tests.test_digital_root, "test_digital_root")
			-- Sorting
			run_test (agent lib_tests.test_bubble_sort, "test_bubble_sort")
			run_test (agent lib_tests.test_quicksort, "test_quicksort")
			-- Data structures
			run_test (agent lib_tests.test_stack_example, "test_stack_example")
			run_test (agent lib_tests.test_queue_example, "test_queue_example")
			run_test (agent lib_tests.test_priority_queue_example, "test_priority_queue_example")
			print ("%N")
		end

	run_tier3_tests
			-- Run Tier 3: Moderate tests.
		do
			print ("Tier 3: Moderate%N")
			print ("-----------------%N")
			run_test (agent lib_tests.test_towers_of_hanoi, "test_towers_of_hanoi")
			run_test (agent lib_tests.test_catalan_numbers, "test_catalan_numbers")
			run_test (agent lib_tests.test_bell_numbers, "test_bell_numbers")
			run_test (agent lib_tests.test_complex_arithmetic, "test_complex_arithmetic")
			run_test (agent lib_tests.test_rational_arithmetic, "test_rational_arithmetic")
			print ("%N")
		end

	run_tier4_tests
			-- Run Tier 4: Complex tests.
		do
			print ("Tier 4: Complex%N")
			print ("---------------%N")
			run_test (agent lib_tests.test_factorial, "test_factorial")
			run_test (agent lib_tests.test_gcd, "test_gcd")
			run_test (agent lib_tests.test_sieve_of_eratosthenes, "test_sieve_of_eratosthenes")
			run_test (agent lib_tests.test_fibonacci_sequence, "test_fibonacci_sequence")
			run_test (agent lib_tests.test_n_queens, "test_n_queens")
			print ("%N")
		end

	run_cipher_tests
			-- Run Cipher tests.
		do
			print ("Ciphers%N")
			print ("-------%N")
			run_test (agent lib_tests.test_atbash_cipher, "test_atbash_cipher")
			run_test (agent lib_tests.test_vigenere_cipher, "test_vigenere_cipher")
			print ("%N")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS
			-- Test suite instance.
		once
			create Result
		end

	passed: INTEGER
			-- Count of passed tests.

	failed: INTEGER
			-- Count of failed tests.

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
