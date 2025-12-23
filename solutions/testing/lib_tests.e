note
	description: "[
		Test suite for Rosetta Code solution classes.

		Tests verify that each solution correctly solves its Rosetta Code task.
		Organized by tier (Tier 1 Trivial through Tier 4 Complex).
	]"
	author: "Simple Eiffel"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Tier 1: Trivial Tests

	test_absolute_value
			-- Test ABSOLUTE_VALUE solution.
		local
			sol: ABSOLUTE_VALUE
		do
			create sol.make
			-- Test basic absolute values
			assert ("abs of positive", sol.abs (42) = 42)
			assert ("abs of negative", sol.abs (-42) = 42)
			assert ("abs of zero", sol.abs (0) = 0)
			assert ("abs of -1", sol.abs (-1) = 1)
			-- Test real version
			assert ("abs_real positive", sol.abs_real (3.14) = 3.14)
			assert ("abs_real negative", sol.abs_real (-3.14) = 3.14)
		end

	test_even_or_odd
			-- Test EVEN_OR_ODD solution.
		local
			sol: EVEN_OR_ODD
		do
			create sol.make
			assert ("0 is even", sol.is_even (0))
			assert ("1 is odd", sol.is_odd (1))
			assert ("2 is even", sol.is_even (2))
			assert ("3 is odd", sol.is_odd (3))
			assert ("100 is even", sol.is_even (100))
			assert ("99 is odd", sol.is_odd (99))
			assert ("-4 is even", sol.is_even (-4))
			assert ("-5 is odd", sol.is_odd (-5))
		end

feature -- Tier 2: Easy Tests - String Operations

	test_reverse_string
			-- Test REVERSE_STRING solution.
		local
			sol: REVERSE_STRING
		do
			create sol.make
			assert ("hello reversed", sol.reverse ("hello").same_string ("olleh"))
			assert ("racecar is palindrome", sol.reverse ("racecar").same_string ("racecar"))
			assert ("empty string", sol.reverse ("").same_string (""))
			assert ("single char", sol.reverse ("A").same_string ("A"))
			assert ("12345 reversed", sol.reverse ("12345").same_string ("54321"))
		end

	test_caesar_cipher
			-- Test CAESAR_CIPHER solution.
		local
			sol: CAESAR_CIPHER
			plain, cipher, decrypted: STRING
		do
			create sol.make
			plain := "Hello World"
			cipher := sol.encrypt (plain, 3)
			decrypted := sol.decrypt (cipher, 3)
			assert ("decryption reverses encryption", decrypted.same_string (plain))

			-- ROT13 is self-inverse
			assert ("rot13 self-inverse", sol.rot13 (sol.rot13 ("Secret")).same_string ("Secret"))
			assert ("rot13 of ABC", sol.rot13 ("ABC").same_string ("NOP"))
		end

	test_palindrome_detection
			-- Test PALINDROME_DETECTION solution.
		local
			sol: PALINDROME_DETECTION
		do
			create sol.make
			assert ("racecar is palindrome", sol.is_palindrome ("racecar"))
			assert ("madam is palindrome", sol.is_palindrome ("madam"))
			assert ("hello is not palindrome", not sol.is_palindrome ("hello"))
			assert ("A is palindrome", sol.is_palindrome ("A"))
			assert ("empty is palindrome", sol.is_palindrome (""))
			assert ("noon is palindrome", sol.is_palindrome ("noon"))
		end

	test_rot13
			-- Test ROT13 solution.
		local
			sol: ROT13
		do
			create sol.make
			assert ("ABC to NOP", sol.rot13 ("ABC").same_string ("NOP"))
			assert ("nop to abc", sol.rot13 ("nop").same_string ("abc"))
			assert ("double rot13", sol.rot13 (sol.rot13 ("Test123")).same_string ("Test123"))
		end

feature -- Tier 2: Easy Tests - Numeric Algorithms

	test_leap_year_check
			-- Test LEAP_YEAR_CHECK solution.
		local
			sol: LEAP_YEAR_CHECK
		do
			create sol.make
			assert ("2000 is leap year", sol.is_leap_year (2000))
			assert ("2004 is leap year", sol.is_leap_year (2004))
			assert ("1900 is not leap year", not sol.is_leap_year (1900))
			assert ("2001 is not leap year", not sol.is_leap_year (2001))
			assert ("2024 is leap year", sol.is_leap_year (2024))
		end

	test_prime_check
			-- Test PRIME_CHECK solution.
		local
			sol: PRIME_CHECK
		do
			create sol.make
			assert ("2 is prime", sol.is_prime (2))
			assert ("3 is prime", sol.is_prime (3))
			assert ("4 is not prime", not sol.is_prime (4))
			assert ("5 is prime", sol.is_prime (5))
			assert ("17 is prime", sol.is_prime (17))
			assert ("100 is not prime", not sol.is_prime (100))
			assert ("1 is not prime", not sol.is_prime (1))
		end

	test_digital_root
			-- Test DIGITAL_ROOT solution.
		local
			sol: DIGITAL_ROOT
		do
			create sol.make
			assert ("digital root of 627615", sol.digital_root (627615) = 9)
			assert ("digital root of 39", sol.digital_root (39) = 3)
			assert ("digital root of 9", sol.digital_root (9) = 9)
			assert ("digital root of 10", sol.digital_root (10) = 1)
		end

feature -- Tier 2: Easy Tests - Sorting Algorithms

	test_bubble_sort
			-- Test BUBBLE_SORT solution.
		local
			sol: BUBBLE_SORT
			arr: ARRAY [INTEGER]
		do
			create sol.make
			arr := <<64, 34, 25, 12, 22, 11, 90>>
			sol.bubble_sort (arr)
			assert ("sorted array", sol.is_sorted (arr))
			assert ("first element", arr [1] = 11)
			assert ("last element", arr [7] = 90)
		end

	test_quicksort
			-- Test QUICKSORT solution.
		local
			sol: QUICKSORT
			arr: ARRAY [INTEGER]
		do
			create sol.make
			arr := <<3, 1, 4, 1, 5, 9, 2, 6, 5, 3>>
			sol.quicksort (arr, arr.lower, arr.upper)
			-- Check manually that array is sorted
			assert ("first is 1", arr [1] = 1)
			assert ("second is 1", arr [2] = 1)
			assert ("last is 9", arr [10] = 9)
			assert ("sorted check", arr [1] <= arr [2] and arr [2] <= arr [3])
		end

feature -- Tier 2: Easy Tests - Data Structures

	test_stack_example
			-- Test STACK_EXAMPLE solution.
		local
			stack: STACK_EXAMPLE [INTEGER]
		do
			create stack.make (10)
			assert ("stack initially empty", stack.is_empty)

			stack.push (1)
			stack.push (2)
			stack.push (3)

			assert ("count is 3", stack.count = 3)
			assert ("top is 3", stack.top = 3)
			assert ("pop returns 3", stack.pop = 3)
			assert ("count is now 2", stack.count = 2)
			assert ("pop returns 2", stack.pop = 2)
			assert ("pop returns 1", stack.pop = 1)
			assert ("stack is empty again", stack.is_empty)
		end

	test_queue_example
			-- Test QUEUE_EXAMPLE solution.
		local
			queue: QUEUE_EXAMPLE [INTEGER]
		do
			create queue.make (10)
			assert ("queue initially empty", queue.is_empty)

			queue.enqueue (1)
			queue.enqueue (2)
			queue.enqueue (3)

			assert ("count is 3", queue.count = 3)
			assert ("front is 1", queue.front = 1)
			assert ("dequeue returns 1", queue.dequeue = 1)
			assert ("count is now 2", queue.count = 2)
			assert ("dequeue returns 2", queue.dequeue = 2)
			assert ("dequeue returns 3", queue.dequeue = 3)
			assert ("queue is empty again", queue.is_empty)
		end

	test_priority_queue_example
			-- Test PRIORITY_QUEUE_EXAMPLE solution.
		local
			pq: PRIORITY_QUEUE_EXAMPLE [INTEGER]
		do
			create pq.make (10)
			assert ("pq initially empty", pq.is_empty)

			pq.insert (5)
			pq.insert (3)
			pq.insert (7)
			pq.insert (1)

			assert ("count is 4", pq.count = 4)
			-- Min-heap: smallest first
			assert ("min is 1", pq.minimum = 1)
			assert ("remove min is 1", pq.remove_minimum = 1)
			assert ("next min is 3", pq.remove_minimum = 3)
			assert ("next min is 5", pq.remove_minimum = 5)
			assert ("next min is 7", pq.remove_minimum = 7)
			assert ("pq is empty", pq.is_empty)
		end

feature -- Tier 3: Moderate Tests

	test_towers_of_hanoi
			-- Test TOWERS_OF_HANOI solution.
		local
			sol: TOWERS_OF_HANOI
		do
			create sol.make
			-- Minimum moves for n disks is 2^n - 1
			assert ("3 disks needs 7 moves", sol.minimum_moves (3) = 7)
			assert ("4 disks needs 15 moves", sol.minimum_moves (4) = 15)
			assert ("5 disks needs 31 moves", sol.minimum_moves (5) = 31)
		end

	test_catalan_numbers
			-- Test CATALAN_NUMBERS solution.
		local
			sol: CATALAN_NUMBERS
		do
			create sol
			-- First few Catalan numbers: 1, 1, 2, 5, 14, 42, 132
			assert ("C(0) = 1", sol.catalan (0) = {NATURAL_64} 1)
			assert ("C(1) = 1", sol.catalan (1) = {NATURAL_64} 1)
			assert ("C(2) = 2", sol.catalan (2) = {NATURAL_64} 2)
			assert ("C(3) = 5", sol.catalan (3) = {NATURAL_64} 5)
			assert ("C(4) = 14", sol.catalan (4) = {NATURAL_64} 14)
			assert ("C(5) = 42", sol.catalan (5) = {NATURAL_64} 42)
		end

	test_bell_numbers
			-- Test BELL_NUMBERS solution.
		local
			sol: BELL_NUMBERS
		do
			create sol
			-- First few Bell numbers: 1, 1, 2, 5, 15, 52, 203
			assert ("B(0) = 1", sol.bell (0) = {NATURAL_64} 1)
			assert ("B(1) = 1", sol.bell (1) = {NATURAL_64} 1)
			assert ("B(2) = 2", sol.bell (2) = {NATURAL_64} 2)
			assert ("B(3) = 5", sol.bell (3) = {NATURAL_64} 5)
			assert ("B(4) = 15", sol.bell (4) = {NATURAL_64} 15)
			assert ("B(5) = 52", sol.bell (5) = {NATURAL_64} 52)
		end

	test_complex_arithmetic
			-- Test COMPLEX_ARITHMETIC solution using operator syntax.
		local
			a, b, c: COMPLEX_ARITHMETIC
		do
			create a.make (3.0, 4.0)  -- 3 + 4i
			create b.make (1.0, 2.0)  -- 1 + 2i

			c := a + b
			assert ("add real", c.real = 4.0)
			assert ("add imag", c.imag = 6.0)

			c := a - b
			assert ("sub real", c.real = 2.0)
			assert ("sub imag", c.imag = 2.0)

			-- (3+4i)(1+2i) = 3 + 6i + 4i + 8i^2 = 3 + 10i - 8 = -5 + 10i
			c := a * b
			assert ("mul real", c.real = -5.0)
			assert ("mul imag", c.imag = 10.0)

			-- |3 + 4i| = 5
			assert ("magnitude", a.magnitude = 5.0)
		end

	test_rational_arithmetic
			-- Test RATIONAL_ARITHMETIC solution using operator syntax.
		local
			a, b, c: RATIONAL_ARITHMETIC
		do
			create a.make (1, 2)  -- 1/2
			create b.make (1, 3)  -- 1/3

			-- 1/2 + 1/3 = 5/6
			c := a + b
			assert ("add num", c.numerator = 5)
			assert ("add den", c.denominator = 6)

			-- 1/2 * 1/3 = 1/6
			c := a * b
			assert ("mul num", c.numerator = 1)
			assert ("mul den", c.denominator = 6)
		end

feature -- Tier 4: Complex Tests

	test_factorial
			-- Test FACTORIAL solution.
		local
			sol: FACTORIAL
		do
			create sol.make
			assert ("0! = 1", sol.factorial_iterative (0) = 1)
			assert ("1! = 1", sol.factorial_iterative (1) = 1)
			assert ("5! = 120", sol.factorial_iterative (5) = 120)
			assert ("10! = 3628800", sol.factorial_iterative (10) = 3628800)

			-- Recursive should match iterative
			assert ("recursive 5!", sol.factorial_recursive (5) = 120)
			assert ("recursive 10!", sol.factorial_recursive (10) = 3628800)

			-- Trailing zeros
			assert ("10! trailing zeros", sol.trailing_zeros (10) = 2)
			assert ("100! trailing zeros", sol.trailing_zeros (100) = 24)

			-- Binomial coefficient: C(5,2) = 10
			assert ("C(5,2) = 10", sol.binomial_coefficient (5, 2) = 10)
			assert ("C(10,3) = 120", sol.binomial_coefficient (10, 3) = 120)
		end

	test_gcd
			-- Test GCD solution.
		local
			sol: GCD
		do
			create sol.make
			assert ("gcd(48, 18) = 6", sol.gcd (48, 18) = 6)
			assert ("gcd(100, 35) = 5", sol.gcd (100, 35) = 5)
			assert ("gcd(1071, 462) = 21", sol.gcd (1071, 462) = 21)
			assert ("gcd(0, 5) = 5", sol.gcd (0, 5) = 5)

			-- Recursive version
			assert ("recursive gcd", sol.gcd_recursive (48, 18) = 6)

			-- LCM: lcm(4, 6) = 12
			assert ("lcm(4, 6) = 12", sol.lcm (4, 6) = 12)
			assert ("lcm(21, 6) = 42", sol.lcm (21, 6) = 42)

			-- Coprime check
			assert ("3 and 5 coprime", sol.coprime (3, 5))
			assert ("4 and 6 not coprime", not sol.coprime (4, 6))
		end

	test_sieve_of_eratosthenes
			-- Test SIEVE_OF_ERATOSTHENES solution.
		local
			sol: SIEVE_OF_ERATOSTHENES
			primes: ARRAYED_LIST [INTEGER]
		do
			create sol.make
			primes := sol.sieve (30)

			-- Primes up to 30: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29
			assert ("10 primes up to 30", primes.count = 10)
			assert ("first prime is 2", primes.first = 2)
			assert ("last prime is 29", primes.last = 29)
			assert ("contains 17", primes.has (17))
			assert ("does not contain 15", not primes.has (15))
		end

	test_fibonacci_sequence
			-- Test FIBONACCI_SEQUENCE solution.
		local
			sol: FIBONACCI_SEQUENCE
		do
			create sol.make
			-- F(0) = 0, F(1) = 1, F(2) = 1, F(3) = 2, F(4) = 3, F(5) = 5
			assert ("fib(0) = 0", sol.fib (0) = {NATURAL_64} 0)
			assert ("fib(1) = 1", sol.fib (1) = {NATURAL_64} 1)
			assert ("fib(2) = 1", sol.fib (2) = {NATURAL_64} 1)
			assert ("fib(5) = 5", sol.fib (5) = {NATURAL_64} 5)
			assert ("fib(10) = 55", sol.fib (10) = {NATURAL_64} 55)
			assert ("fib(20) = 6765", sol.fib (20) = {NATURAL_64} 6765)
		end

	test_n_queens
			-- Test N_QUEENS solution.
		local
			sol: N_QUEENS
			solutions: ARRAYED_LIST [ARRAY [INTEGER]]
		do
			create sol
			-- 4-queens has 2 solutions
			solutions := sol.solve (4)
			assert ("4-queens has 2 solutions", solutions.count = 2)

			-- 8-queens has 92 solutions
			solutions := sol.solve (8)
			assert ("8-queens has 92 solutions", solutions.count = 92)
		end

feature -- Cipher Tests

	test_atbash_cipher
			-- Test ATBASH_CIPHER solution.
		local
			sol: ATBASH_CIPHER
		do
			create sol.make
			-- Atbash is self-inverse: A->Z, B->Y, etc.
			assert ("atbash ABC", sol.atbash ("ABC").same_string ("ZYX"))
			assert ("self-inverse", sol.atbash (sol.atbash ("Hello")).same_string ("Hello"))
		end

	test_vigenere_cipher
			-- Test VIGENERE_CIPHER solution.
		local
			sol: VIGENERE_CIPHER
			plain, key, cipher, decrypted: STRING
		do
			create sol.make
			plain := "ATTACKATDAWN"
			key := "LEMON"
			cipher := sol.encrypt (plain, key)
			decrypted := sol.decrypt (cipher, key)
			assert ("vigenere decrypt reverses encrypt", decrypted.same_string (plain))
		end

end
