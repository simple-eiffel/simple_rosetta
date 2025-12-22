note
	description: "[
		Rosetta Code: Generate lower case ASCII alphabet
		https://rosettacode.org/wiki/Generate_lower_case_ASCII_alphabet

		Generate the lowercase ASCII alphabet.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Generate_lower_case_ASCII_alphabet"
	tier: "2"

class
	GENERATE_LOWERCASE_ALPHABET

create
	make

feature {NONE} -- Initialization

	make
			-- Generate and display lowercase alphabet.
		do
			print ("Lowercase alphabet: " + lowercase_alphabet + "%N")
			print ("Uppercase alphabet: " + uppercase_alphabet + "%N")
			print ("As array: ")
			across lowercase_alphabet_array as l_c loop
				print (l_c.out + " ")
			end
			print ("%N")
		end

feature -- Generation

	lowercase_alphabet: STRING
			-- Generate lowercase alphabet string.
		local
			l_c: CHARACTER
		do
			create Result.make (26)
			from l_c := 'a' until l_c > 'z' loop
				Result.append_character (l_c)
				l_c := (l_c.code + 1).to_character_8
			end
		ensure
			correct_length: Result.count = 26
		end

	uppercase_alphabet: STRING
			-- Generate uppercase alphabet string.
		local
			l_c: CHARACTER
		do
			create Result.make (26)
			from l_c := 'A' until l_c > 'Z' loop
				Result.append_character (l_c)
				l_c := (l_c.code + 1).to_character_8
			end
		ensure
			correct_length: Result.count = 26
		end

	lowercase_alphabet_array: ARRAY [CHARACTER]
			-- Generate lowercase alphabet as array.
		local
			l_c: CHARACTER
			l_i: INTEGER
		do
			create Result.make_filled ('a', 1, 26)
			from l_c := 'a'; l_i := 1 until l_c > 'z' loop
				Result [l_i] := l_c
				l_c := (l_c.code + 1).to_character_8
				l_i := l_i + 1
			end
		ensure
			correct_length: Result.count = 26
		end

end
