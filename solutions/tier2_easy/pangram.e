note
	description: "[
		Rosetta Code: Pangram checker
		https://rosettacode.org/wiki/Pangram_checker

		Check if a string is a pangram (contains all letters of alphabet).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Pangram_checker"
	tier: "2"

class
	PANGRAM

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate pangram checking.
		do
			print ("Pangram Checker%N")
			print ("===============%N%N")

			test ("The quick brown fox jumps over the lazy dog")
			test ("The quick brown fox jumped over the lazy dog")
			test ("Pack my box with five dozen liquor jugs")
			test ("Hello World")
		end

feature -- Testing

	test (a_str: STRING)
			-- Test if string is a pangram.
		do
			print ("'" + a_str + "'%N  -> ")
			if is_pangram (a_str) then
				print ("IS a pangram%N")
			else
				print ("NOT a pangram (missing: " + missing_letters (a_str) + ")%N")
			end
			print ("%N")
		end

feature -- Query

	is_pangram (a_str: STRING): BOOLEAN
			-- Does `a_str' contain all 26 letters?
		require
			str_exists: a_str /= Void
		local
			l_lower: STRING
			l_c: CHARACTER
		do
			l_lower := a_str.as_lower
			Result := True
			from l_c := 'a' until l_c > 'z' or not Result loop
				if not l_lower.has (l_c) then
					Result := False
				end
				l_c := (l_c.code + 1).to_character_8
			end
		end

	missing_letters (a_str: STRING): STRING
			-- Letters missing from `a_str'.
		require
			str_exists: a_str /= Void
		local
			l_lower: STRING
			l_c: CHARACTER
		do
			l_lower := a_str.as_lower
			create Result.make (26)
			from l_c := 'a' until l_c > 'z' loop
				if not l_lower.has (l_c) then
					Result.append_character (l_c)
				end
				l_c := (l_c.code + 1).to_character_8
			end
		ensure
			result_exists: Result /= Void
		end

end