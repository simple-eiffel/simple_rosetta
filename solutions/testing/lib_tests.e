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

	test_array_first_last
			-- Test ARRAY_FIRST_LAST solution.
		local
			sol: ARRAY_FIRST_LAST
			arr: ARRAY [INTEGER]
		do
			create sol
			arr := <<10, 20, 30, 40, 50>>
			assert ("first is 10", attached {INTEGER} sol.first (arr) as f and then f = 10)
			assert ("last is 50", attached {INTEGER} sol.last (arr) as l and then l = 50)
		end

	test_is_string_numeric
			-- Test IS_STRING_NUMERIC solution.
		local
			sol: IS_STRING_NUMERIC
		do
			create sol.make
			assert ("42 is numeric", sol.is_numeric ("42"))
			assert ("-17 is numeric", sol.is_numeric ("-17"))
			assert ("3.14159 is numeric", sol.is_numeric ("3.14159"))
			assert ("hello not numeric", not sol.is_numeric ("hello"))
			assert ("empty not numeric", not sol.is_numeric (""))
			assert ("  123  is numeric", sol.is_numeric ("  123  "))
		end

	test_string_length
			-- Test STRING_LENGTH solution.
		local
			sol: STRING_LENGTH
		do
			create sol.make
			assert ("empty string length", sol.length ("") = 0)
			assert ("a length 1", sol.length ("a") = 1)
			assert ("hello length 5", sol.length ("Hello") = 5)
			assert ("byte length", sol.byte_length ("test") = 4)
		end

	test_increment
			-- Test INCREMENT solution.
		local
			sol: INCREMENT
		do
			create sol.make
			assert ("12345 increments to 12346", sol.increment_string ("12345").same_string ("12346"))
			assert ("999 increments to 1000", sol.increment_string ("999").same_string ("1000"))
			assert ("0 increments to 1", sol.increment_string ("0").same_string ("1"))
		end

	test_string_append
			-- Test STRING_APPEND solution.
		local
			sol: STRING_APPEND
		do
			create sol.make
			assert ("hello + world", sol.concatenate ("Hello", ", World!").same_string ("Hello, World!"))
			assert ("empty + test", sol.concatenate ("", "test").same_string ("test"))
			assert ("test + empty", sol.concatenate ("test", "").same_string ("test"))
		end

	test_string_concatenation
			-- Test STRING_CONCATENATION solution.
		local
			sol: STRING_CONCATENATION
		do
			create sol.make
			assert ("A + B", sol.concat ("A", "B").same_string ("AB"))
			assert ("Hello + World", sol.concat ("Hello, ", "World!").same_string ("Hello, World!"))
		end

	test_empty_string
			-- Test EMPTY_STRING solution.
		local
			sol: EMPTY_STRING
		do
			create sol.make
			assert ("empty is empty", sol.is_empty (""))
			assert ("hello not empty", not sol.is_empty ("Hello"))
			assert ("blank is blank", sol.is_blank ("   "))
			assert ("empty is blank", sol.is_blank (""))
			assert ("hello not blank", not sol.is_blank ("Hello"))
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

feature -- Tier 2: Easy Tests - Math/Statistics

	test_arithmetic_mean
			-- Test ARITHMETIC_MEAN solution.
		local
			sol: ARITHMETIC_MEAN
		do
			create sol.make
			assert ("mean of 1-10 is 5.5", sol.mean (<<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>) = 5.5)
			assert ("mean of empty is 0", sol.mean (<<>>) = 0.0)
			assert ("mean of single is itself", sol.mean (<<7.0>>) = 7.0)
		end

	test_maximum
			-- Test MAXIMUM solution.
		local
			sol: MAXIMUM
		do
			create sol.make
			assert ("max of 3,1,4,1,5,9", sol.maximum (<<3, 1, 4, 1, 5, 9>>) = 9)
			assert ("max of negatives", sol.maximum (<<-5, -3, -10, -1>>) = -1)
			assert ("max of single", sol.maximum (<<42>>) = 42)
		end

	test_minimum
			-- Test MINIMUM solution.
		local
			sol: MINIMUM
		do
			create sol.make
			assert ("min of 3,1,4,1,5,9", sol.minimum (<<3, 1, 4, 1, 5, 9>>) = 1)
			assert ("min of negatives", sol.minimum (<<-5, -3, -10, -1>>) = -10)
			assert ("min of single", sol.minimum (<<42>>) = 42)
		end

	test_sum_of_list
			-- Test SUM_OF_LIST solution.
		local
			sol: SUM_OF_LIST
		do
			create sol.make
			assert ("sum of 1-10 is 55", sol.sum (<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>) = {INTEGER_64} 55)
			assert ("product of 1-5 is 120", sol.product (<<1, 2, 3, 4, 5>>) = {INTEGER_64} 120)
			assert ("sum of empty is 0", sol.sum (<<>>) = {INTEGER_64} 0)
		end

feature -- Tier 2: Easy Tests - String Analysis

	test_pangram
			-- Test PANGRAM solution.
		local
			sol: PANGRAM
		do
			create sol.make
			assert ("quick brown fox", sol.is_pangram ("The quick brown fox jumps over the lazy dog"))
			assert ("pack my box", sol.is_pangram ("Pack my box with five dozen liquor jugs"))
			assert ("hello world not pangram", not sol.is_pangram ("Hello World"))
			assert ("missing letters", sol.missing_letters ("Hello").count > 0)
		end

	test_isogram
			-- Test ISOGRAM solution.
		local
			sol: ISOGRAM
		do
			create sol.make
			assert ("subdermatoglyphic is isogram", sol.is_isogram ("subdermatoglyphic"))
			assert ("hello not isogram", not sol.is_isogram ("hello"))
			assert ("empty is isogram", sol.is_isogram (""))
			assert ("a is isogram", sol.is_isogram ("a"))
			assert ("first duplicate in hello is l", sol.first_duplicate ("hello") = 'l')
		end

	test_is_palindrome
			-- Test IS_PALINDROME solution.
		local
			sol: IS_PALINDROME
		do
			create sol.make
			assert ("racecar palindrome", sol.is_palindrome ("racecar"))
			assert ("level palindrome", sol.is_palindrome ("level"))
			assert ("hello not palindrome", not sol.is_palindrome ("hello"))
			assert ("panama with spaces", sol.is_palindrome ("A man a plan a canal Panama"))
			assert ("exact: noon", sol.is_exact_palindrome ("noon"))
			assert ("exact: hello no", not sol.is_exact_palindrome ("hello"))
		end

	test_anagram_detector
			-- Test ANAGRAM_DETECTOR solution.
		local
			sol: ANAGRAM_DETECTOR
		do
			create sol.make
			assert ("listen-silent anagrams", sol.are_anagrams ("listen", "silent"))
			assert ("triangle-integral anagrams", sol.are_anagrams ("triangle", "integral"))
			assert ("hello-world not anagrams", not sol.are_anagrams ("hello", "world"))
			assert ("abc-cab anagrams", sol.are_anagrams ("abc", "cab"))
		end

feature -- Tier 2: Easy Tests - String Manipulation

	test_trim_string
			-- Test TRIM_STRING solution.
		local
			sol: TRIM_STRING
		do
			create sol.make
			assert ("trim both", sol.trim ("   hello   ").same_string ("hello"))
			assert ("trim left", sol.trim_left ("   hello   ").same_string ("hello   "))
			assert ("trim right", sol.trim_right ("   hello   ").same_string ("   hello"))
			assert ("no trim needed", sol.trim ("hello").same_string ("hello"))
		end

	test_repeat_string
			-- Test REPEAT_STRING solution.
		local
			sol: REPEAT_STRING
		do
			create sol.make
			assert ("ha x 5", sol.repeat ("ha", 5).same_string ("hahahahaha"))
			assert ("abc x 0", sol.repeat ("abc", 0).same_string (""))
			assert ("x x 3", sol.repeat ("x", 3).same_string ("xxx"))
			assert ("repeat char *", sol.repeat_char ('*', 5).same_string ("*****"))
		end

	test_remove_vowels
			-- Test REMOVE_VOWELS solution.
		local
			sol: REMOVE_VOWELS
		do
			create sol.make
			assert ("hello -> hll", sol.remove_vowels ("hello").same_string ("hll"))
			assert ("aeiou -> empty", sol.remove_vowels ("aeiou").same_string (""))
			assert ("rhythm unchanged", sol.remove_vowels ("rhythm").same_string ("rhythm"))
			assert ("is vowel a", sol.is_vowel ('a'))
			assert ("is vowel E", sol.is_vowel ('E'))
			assert ("b not vowel", not sol.is_vowel ('b'))
		end

	test_binary_digits
			-- Test BINARY_DIGITS solution.
		local
			sol: BINARY_DIGITS
		do
			create sol.make
			assert ("5 is 101", sol.to_binary (5).same_string ("101"))
			assert ("0 is 0", sol.to_binary (0).same_string ("0"))
			assert ("255 is 11111111", sol.to_binary (255).same_string ("11111111"))
			assert ("8 is 1000", sol.to_binary (8).same_string ("1000"))
		end

	test_count_occurrences
			-- Test COUNT_OCCURRENCES solution.
		local
			sol: COUNT_OCCURRENCES
		do
			create sol.make
			assert ("th in truths", sol.count_occurrences ("the three truths", "th") = 3)
			assert ("o in hello world", sol.count_occurrences ("hello world", "o") = 2)
			assert ("xyz not found", sol.count_occurrences ("hello world", "xyz") = 0)
			assert ("overlapping aa", sol.count_overlapping ("aaaaaa", "aa") = 5)
		end

	test_string_case
			-- Test STRING_CASE solution.
		local
			sol: STRING_CASE
		do
			create sol.make
			assert ("upper", sol.to_upper ("hello").same_string ("HELLO"))
			assert ("lower", sol.to_lower ("HELLO").same_string ("hello"))
			assert ("title", sol.to_title ("hello world").same_string ("Hello World"))
			assert ("capitalize", sol.capitalize ("hello world").same_string ("Hello world"))
			assert ("swap case", sol.swap_case ("Hello").same_string ("hELLO"))
		end

	test_word_wrap
			-- Test WORD_WRAP solution.
		local
			sol: WORD_WRAP
			wrapped: STRING
		do
			create sol.make
			wrapped := sol.word_wrap ("hello world from Eiffel", 12)
			-- Should have at least one newline for short width
			assert ("wrapped has newlines", wrapped.has ('%N'))
			assert ("not empty", not wrapped.is_empty)
		end

	test_run_length_encoding
			-- Test RUN_LENGTH_ENCODING solution.
		local
			sol: RUN_LENGTH_ENCODING
			encoded, decoded: STRING
		do
			create sol.make
			encoded := sol.encode ("WWWWB")
			assert ("encode WWWWB", encoded.same_string ("4W1B"))
			decoded := sol.decode (encoded)
			assert ("decode back", decoded.same_string ("WWWWB"))
			assert ("roundtrip", sol.decode (sol.encode ("AAABBBCCC")).same_string ("AAABBBCCC"))
		end

	test_power
			-- Test POWER solution.
		local
			sol: POWER
		do
			create sol.make
			assert ("2^10 = 1024", sol.power (2, 10) = 1024.0)
			assert ("3^4 = 81", sol.power (3, 4) = 81.0)
			assert ("10^0 = 1", sol.power (10, 0) = 1.0)
			assert ("power_int 2^10", sol.power_int (2, 10) = {INTEGER_64} 1024)
			assert ("power_int 5^3", sol.power_int (5, 3) = {INTEGER_64} 125)
		end

	test_sum_digits
			-- Test SUM_DIGITS solution.
		local
			sol: SUM_DIGITS
		do
			create sol.make
			assert ("sum_digits 12345", sol.sum_digits (12345) = 15)
			assert ("sum_digits 999", sol.sum_digits (999) = 27)
			assert ("sum_digits 0", sol.sum_digits (0) = 0)
			assert ("sum_digits 1", sol.sum_digits (1) = 1)
			assert ("binary sum 255", sol.sum_digits_base (255, 2) = 8)
		end

	test_lipogram
			-- Test LIPOGRAM solution.
		local
			sol: LIPOGRAM
		do
			create sol.make
			assert ("pangram not lipogram for e", not sol.is_lipogram ("The quick brown fox jumps over the lazy dog", 'e'))
			assert ("no e is lipogram for e", sol.is_lipogram ("no fifth symbol", 'e'))
			assert ("missing letters", sol.missing_letters ("Hello").count > 0)
		end

	test_left_pad
			-- Test LEFT_PAD solution.
		local
			sol: LEFT_PAD
		do
			create sol.make
			assert ("pad hello", sol.left_pad ("hello", 10, ' ').same_string ("     hello"))
			assert ("pad 42 with zeros", sol.left_pad ("42", 5, '0').same_string ("00042"))
			assert ("no pad needed", sol.left_pad ("long string", 5, '*').same_string ("long string"))
			assert ("right pad", sol.right_pad ("hello", 10, ' ').same_string ("hello     "))
		end

	test_median
			-- Test MEDIAN solution.
		local
			sol: MEDIAN
		do
			create sol.make
			-- Odd count: median of [1,5,2,8,7] sorted is [1,2,5,7,8], median is 5
			assert ("median odd count", sol.median (<<1.0, 5.0, 2.0, 8.0, 7.0>>) = 5.0)
			-- Even count: median of [1,5,2,8,7,9] sorted is [1,2,5,7,8,9], median is (5+7)/2 = 6
			assert ("median even count", sol.median (<<1.0, 5.0, 2.0, 8.0, 7.0, 9.0>>) = 6.0)
		end

	test_integer_square_root
			-- Test INTEGER_SQUARE_ROOT solution.
		local
			sol: INTEGER_SQUARE_ROOT
		do
			create sol.make
			assert ("isqrt(0)", sol.isqrt (0) = {INTEGER_64} 0)
			assert ("isqrt(4)", sol.isqrt (4) = {INTEGER_64} 2)
			assert ("isqrt(10)", sol.isqrt (10) = {INTEGER_64} 3)
			assert ("isqrt(100)", sol.isqrt (100) = {INTEGER_64} 10)
			assert ("isqrt(1000000)", sol.isqrt (1000000) = {INTEGER_64} 1000)
		end

	test_temperature_conversion
			-- Test TEMPERATURE_CONVERSION solution.
		local
			sol: TEMPERATURE_CONVERSION
		do
			create sol.make
			assert ("0C to F", sol.celsius_to_fahrenheit (0.0) = 32.0)
			assert ("100C to F", (sol.celsius_to_fahrenheit (100.0) - 212.0).abs < 0.001)
			assert ("32F to C", sol.fahrenheit_to_celsius (32.0) = 0.0)
			assert ("212F to C", (sol.fahrenheit_to_celsius (212.0) - 100.0).abs < 0.001)
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

	test_levenshtein_distance
			-- Test LEVENSHTEIN_DISTANCE solution.
		local
			sol: LEVENSHTEIN_DISTANCE
		do
			create sol.make
			assert ("kitten-sitting = 3", sol.distance ("kitten", "sitting") = 3)
			assert ("hello-hello = 0", sol.distance ("hello", "hello") = 0)
			assert ("empty-abc = 3", sol.distance ("", "abc") = 3)
			assert ("abc-empty = 3", sol.distance ("abc", "") = 3)
			assert ("saturday-sunday", sol.distance ("saturday", "sunday") = 3)
		end

	test_hamming_distance
			-- Test HAMMING_DISTANCE solution.
		local
			sol: HAMMING_DISTANCE
		do
			create sol.make
			assert ("karolin-kathrin = 3", sol.distance ("karolin", "kathrin") = 3)
			assert ("hello-hello = 0", sol.distance ("hello", "hello") = 0)
			assert ("1011101-1001001 = 2", sol.distance ("1011101", "1001001") = 2)
			-- 37 = 100101, 5 = 000101, XOR = 100000 (1 bit different)
			assert ("binary 37 vs 5", sol.binary_distance (37, 5) = 1)
		end

	test_rms
			-- Test RMS solution.
		local
			sol: RMS
		do
			create sol.make
			-- RMS of 1-10 is approximately 6.2048
			assert ("rms non-zero", sol.root_mean_square (<<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>) > 6.0)
			assert ("rms > arithmetic mean", sol.root_mean_square (<<1.0, 2.0, 3.0, 4.0, 5.0>>) >= sol.arithmetic_mean (<<1.0, 2.0, 3.0, 4.0, 5.0>>))
		end

	test_pythagorean_means
			-- Test PYTHAGOREAN_MEANS solution.
		local
			sol: PYTHAGOREAN_MEANS
			arr: ARRAY [REAL_64]
			am, gm, hm: REAL_64
		do
			create sol.make
			arr := <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>
			am := sol.arithmetic_mean (arr)
			gm := sol.geometric_mean (arr)
			hm := sol.harmonic_mean (arr)
			-- A >= G >= H for positive numbers
			assert ("AM >= GM", am >= gm)
			assert ("GM >= HM", gm >= hm)
			assert ("AM = 5.5", am = 5.5)
		end

	test_insertion_sort
			-- Test INSERTION_SORT solution.
		local
			sol: INSERTION_SORT
			arr: ARRAY [INTEGER]
		do
			create sol.make
			arr := <<64, 34, 25, 12, 22, 11, 90>>
			sol.insertion_sort (arr)
			assert ("sorted after insertion sort", sol.is_sorted (arr))
			assert ("first is 11", arr [1] = 11)
			assert ("last is 90", arr [7] = 90)
		end

feature -- Tier 4: Complex Tests

	test_binary_search
			-- Test BINARY_SEARCH solution.
		local
			sol: BINARY_SEARCH
			arr: ARRAY [INTEGER]
		do
			create sol.make
			arr := <<2, 5, 8, 12, 16, 23, 38, 56, 72, 91>>
			assert ("find 23", sol.binary_search (arr, 23) = 6)
			assert ("find 2 (first)", sol.binary_search (arr, 2) = 1)
			assert ("find 91 (last)", sol.binary_search (arr, 91) = 10)
			assert ("not found 50", sol.binary_search (arr, 50) = -1)
			assert ("recursive find 38", sol.binary_search_recursive (arr, 38, 1, 10) = 7)
		end

	test_mergesort
			-- Test MERGESORT solution.
		local
			sol: MERGESORT
			arr: ARRAY [INTEGER]
		do
			create sol.make
			arr := <<38, 27, 43, 3, 9, 82, 10>>
			sol.merge_sort (arr)
			-- Verify sorted: 3, 9, 10, 27, 38, 43, 82
			assert ("first is 3", arr [1] = 3)
			assert ("second is 9", arr [2] = 9)
			assert ("third is 10", arr [3] = 10)
			assert ("fourth is 27", arr [4] = 27)
			assert ("fifth is 38", arr [5] = 38)
			assert ("sixth is 43", arr [6] = 43)
			assert ("last is 82", arr [7] = 82)
		end

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
