note
	description: "[
		Rosetta Code: String length
		https://rosettacode.org/wiki/String_length

		Determine the length of a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_length"
	tier: "1"

class
	STRING_LENGTH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string length.
		do
			print ("String Length%N")
			print ("=============%N%N")

			show_length ("")
			show_length ("a")
			show_length ("Hello")
			show_length ("Hello, World!")
			show_length ("Eiffel programming language")
		end

feature -- Display

	show_length (a_str: STRING)
			-- Print string and its length.
		do
			print ("'" + a_str + "' -> " + a_str.count.out + " characters%N")
		end

feature -- Query

	length (a_str: STRING): INTEGER
			-- Length of string.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.count
		ensure
			non_negative: Result >= 0
		end

	byte_length (a_str: STRING): INTEGER
			-- Byte length (same as character count for STRING_8).
		require
			str_exists: a_str /= Void
		do
			Result := a_str.count
		ensure
			non_negative: Result >= 0
		end

end