note
	description: "[
		Rosetta Code: Remove vowels from a string
		https://rosettacode.org/wiki/Remove_vowels_from_a_string

		Remove all vowels from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Remove_vowels_from_a_string"
	tier: "2"

class
	REMOVE_VOWELS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate vowel removal.
		do
			print ("Remove Vowels%N")
			print ("=============%N%N")

			demo ("The quick brown fox jumps over the lazy dog")
			demo ("HELLO WORLD")
			demo ("aeiou")
			demo ("rhythm")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show result.
		do
			print ("'" + a_str + "'%N  -> '" + remove_vowels (a_str) + "'%N%N")
		end

feature -- Operations

	remove_vowels (a_str: STRING): STRING
			-- String with vowels removed.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if not is_vowel (l_c) then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			no_longer: Result.count <= a_str.count
		end

	is_vowel (a_char: CHARACTER): BOOLEAN
			-- Is character a vowel?
		local
			l_lower: CHARACTER
		do
			l_lower := a_char.as_lower
			Result := l_lower = 'a' or l_lower = 'e' or l_lower = 'i' or
			          l_lower = 'o' or l_lower = 'u'
		end

	only_vowels (a_str: STRING): STRING
			-- Only the vowels from string.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if is_vowel (l_c) then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end