note
	description: "[
		Rosetta Code: Palindrome detection
		https://rosettacode.org/wiki/Palindrome_detection

		Check if a string is a palindrome.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Palindrome_detection"
	tier: "2"

class
	IS_PALINDROME

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate palindrome checking.
		do
			print ("Palindrome Check%N")
			print ("================%N%N")

			test ("racecar")
			test ("level")
			test ("hello")
			test ("A man a plan a canal Panama")
			test ("noon")
			test ("abc")
		end

feature -- Testing

	test (a_str: STRING)
			-- Test if palindrome.
		do
			print ("'" + a_str + "': ")
			if is_palindrome (a_str) then
				print ("YES%N")
			else
				print ("NO%N")
			end
		end

feature -- Detection

	is_palindrome (a_str: STRING): BOOLEAN
			-- Is string a palindrome (ignoring case and non-letters)?
		require
			str_exists: a_str /= Void
		local
			l_clean: STRING
			l_i, l_j: INTEGER
		do
			l_clean := letters_only (a_str.as_lower)
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

	is_exact_palindrome (a_str: STRING): BOOLEAN
			-- Is string exactly equal to its reverse?
		require
			str_exists: a_str /= Void
		local
			l_rev: STRING
		do
			l_rev := a_str.twin
			l_rev.mirror
			Result := a_str.same_string (l_rev)
		end

feature {NONE} -- Helpers

	letters_only (a_str: STRING): STRING
			-- Extract only letters.
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if (l_c >= 'a' and l_c <= 'z') or (l_c >= 'A' and l_c <= 'Z') then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		end

end