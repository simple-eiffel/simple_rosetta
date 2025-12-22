note
	description: "[
		Rosetta Code: Palindrome detection
		https://rosettacode.org/wiki/Palindrome_detection

		Check if a string is a palindrome.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Palindrome_detection"

class
	PALINDROME

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate palindrome detection.
		local
			test_strings: ARRAY [STRING]
			i: INTEGER
			s: STRING
		do
			print ("Palindrome Detection%N")
			print ("====================%N%N")

			test_strings := <<"racecar", "level", "hello", "A man a plan a canal Panama",
				"Was it a car or a cat I saw", "No lemon no melon", "palindrome", "Madam">>

			from i := test_strings.lower until i > test_strings.upper loop
				s := test_strings [i]
				print ("%"" + s + "%": ")
				if is_palindrome (s) then
					print ("YES (exact)%N")
				elseif is_palindrome_ignore_case_spaces (s) then
					print ("YES (ignoring case/spaces)%N")
				else
					print ("NO%N")
				end
				i := i + 1
			end

			-- Numeric palindromes
			print ("%NNumeric palindromes:%N")
			print ("  12321 is palindrome: " + is_numeric_palindrome (12321).out + "%N")
			print ("  12345 is palindrome: " + is_numeric_palindrome (12345).out + "%N")
		end

feature -- Palindrome Detection

	is_palindrome (s: STRING): BOOLEAN
			-- Is s an exact palindrome?
		local
			left, right: INTEGER
		do
			if s.is_empty then
				Result := True
			else
				Result := True
				left := 1
				right := s.count
				from until left >= right or not Result loop
					if s.item (left) /= s.item (right) then
						Result := False
					end
					left := left + 1
					right := right - 1
				end
			end
		end

	is_palindrome_ignore_case_spaces (s: STRING): BOOLEAN
			-- Is s a palindrome ignoring case and non-alphanumeric characters?
		local
			cleaned: STRING
			i: INTEGER
			c: CHARACTER
		do
			-- Clean string: keep only alphanumeric, convert to lower
			create cleaned.make (s.count)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c.is_alpha or c.is_digit then
					cleaned.append_character (c.as_lower)
				end
				i := i + 1
			end
			Result := is_palindrome (cleaned)
		end

	is_numeric_palindrome (n: INTEGER): BOOLEAN
			-- Is n a numeric palindrome?
		local
			original, reversed, digit: INTEGER
			num: INTEGER
		do
			if n < 0 then
				Result := False
			else
				original := n
				reversed := 0
				num := n
				from until num = 0 loop
					digit := num \\ 10
					reversed := reversed * 10 + digit
					num := num // 10
				end
				Result := original = reversed
			end
		end

	longest_palindrome_substring (s: STRING): STRING
			-- Find the longest palindromic substring in s.
		local
			i, j: INTEGER
			max_start, max_len: INTEGER
			len1, len2, len: INTEGER
		do
			if s.is_empty then
				create Result.make_empty
			else
				max_start := 1
				max_len := 1

				from i := 1 until i > s.count loop
					-- Odd length palindrome centered at i
					len1 := expand_around_center (s, i, i)
					-- Even length palindrome centered between i and i+1
					len2 := expand_around_center (s, i, i + 1)
					len := len1.max (len2)

					if len > max_len then
						max_len := len
						max_start := i - (len - 1) // 2
					end
					i := i + 1
				end

				Result := s.substring (max_start, max_start + max_len - 1)
			end
		end

feature {NONE} -- Helpers

	expand_around_center (s: STRING; left, right: INTEGER): INTEGER
			-- Expand around center and return length of palindrome.
		local
			l, r: INTEGER
		do
			l := left
			r := right
			from until l < 1 or r > s.count or s.item (l) /= s.item (r) loop
				l := l - 1
				r := r + 1
			end
			Result := r - l - 1
		end

end
