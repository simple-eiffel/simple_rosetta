note
	description: "[
		Rosetta Code: Palindrome detection
		https://rosettacode.org/wiki/Palindrome_detection

		Determine if a string is a palindrome.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Palindrome_detection"
	tier: "2"

class
	PALINDROME_DETECTION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate palindrome detection.
		do
			print ("Palindrome Detection%N")
			print ("====================%N%N")

			test_palindrome ("racecar")
			test_palindrome ("level")
			test_palindrome ("hello")
			test_palindrome ("A man a plan a canal Panama")
			test_palindrome ("Was it a car or a cat I saw")
			test_palindrome ("Not a palindrome")
		end

feature -- Testing

	test_palindrome (a_str: STRING)
			-- Test if string is palindrome.
		do
			print ("'" + a_str + "' -> ")
			if is_palindrome (a_str) then
				print ("YES (palindrome)%N")
			else
				print ("NO%N")
			end
		end

feature -- Detection

	is_palindrome (a_str: STRING): BOOLEAN
			-- Is `a_str' a palindrome (ignoring case and non-letters)?
		require
			str_exists: a_str /= Void
		local
			l_clean: STRING
			l_i, l_j: INTEGER
		do
			l_clean := clean_string (a_str)
			Result := True
			l_i := 1
			l_j := l_clean.count
			from until l_i >= l_j or not Result loop
				if l_clean [l_i] /= l_clean [l_j] then
					Result := False
				end
				l_i := l_i + 1
				l_j := l_j - 1
			end
		end

	is_simple_palindrome (a_str: STRING): BOOLEAN
			-- Is `a_str' exactly equal to its reverse?
		require
			str_exists: a_str /= Void
		local
			l_reversed: STRING
		do
			l_reversed := a_str.twin
			l_reversed.mirror
			Result := a_str.same_string (l_reversed)
		end

feature {NONE} -- Helpers

	clean_string (a_str: STRING): STRING
			-- Remove non-letters and convert to lowercase.
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i].as_lower
				if l_c >= 'a' and l_c <= 'z' then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		end

end
