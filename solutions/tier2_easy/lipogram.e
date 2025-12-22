note
	description: "[
		Rosetta Code: Lipogram checker
		https://rosettacode.org/wiki/Lipogram_checker

		Check if text is a lipogram (missing a specific letter).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Lipogram_checker"
	tier: "2"

class
	LIPOGRAM

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate lipogram checking.
		local
			l_text: STRING
		do
			print ("Lipogram Checker%N")
			print ("================%N%N")

			l_text := "The quick brown fox jumps over the lazy dog"
			test (l_text, 'e')

			l_text := "A jovial swamp fox hit an icy bog"
			test (l_text, 'e')

			l_text := "This string lacks that particular symbol"
			test (l_text, 'e')
		end

feature -- Testing

	test (a_text: STRING; a_letter: CHARACTER)
			-- Test if text is a lipogram avoiding letter.
		do
			print ("Text: '" + a_text + "'%N")
			print ("Letter: '" + a_letter.out + "'%N")
			if is_lipogram (a_text, a_letter) then
				print ("-> IS a lipogram (avoids '" + a_letter.out + "')%N")
			else
				print ("-> NOT a lipogram (contains '" + a_letter.out + "')%N")
			end
			print ("%N")
		end

feature -- Query

	is_lipogram (a_text: STRING; a_letter: CHARACTER): BOOLEAN
			-- Does `a_text' avoid `a_letter'?
		require
			text_exists: a_text /= Void
		do
			Result := not a_text.as_lower.has (a_letter.as_lower)
		end

	missing_letters (a_text: STRING): STRING
			-- All letters missing from text.
		require
			text_exists: a_text /= Void
		local
			l_lower: STRING
			l_c: CHARACTER
		do
			l_lower := a_text.as_lower
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