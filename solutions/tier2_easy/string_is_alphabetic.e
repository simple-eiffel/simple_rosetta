note
	description: "[
		Rosetta Code: Determine if a string is alphabetic
		https://rosettacode.org/wiki/Determine_if_a_string_is_alphabetic

		Check if a string contains only alphabetic characters.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_is_alphabetic"
	tier: "2"

class
	STRING_IS_ALPHABETIC

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate alphabetic detection.
		do
			print ("Is String Alphabetic?%N")
			print ("=====================%N%N")

			test ("Hello")
			test ("hello")
			test ("HELLO")
			test ("Hello123")
			test ("Hello World")
			test ("")
		end

feature -- Testing

	test (a_str: STRING)
			-- Test if string is alphabetic.
		do
			print ("'" + a_str + "' -> ")
			if is_alphabetic (a_str) then
				print ("Yes%N")
			else
				print ("No%N")
			end
		end

feature -- Query

	is_alphabetic (a_str: STRING): BOOLEAN
			-- Does string contain only alphabetic characters?
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			Result := not a_str.is_empty
			from l_i := 1 until l_i > a_str.count or not Result loop
				l_c := a_str [l_i]
				Result := (l_c >= 'A' and l_c <= 'Z') or (l_c >= 'a' and l_c <= 'z')
				l_i := l_i + 1
			end
		end

	is_alphanumeric (a_str: STRING): BOOLEAN
			-- Does string contain only letters and digits?
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			Result := not a_str.is_empty
			from l_i := 1 until l_i > a_str.count or not Result loop
				l_c := a_str [l_i]
				Result := (l_c >= 'A' and l_c <= 'Z') or
				          (l_c >= 'a' and l_c <= 'z') or
				          (l_c >= '0' and l_c <= '9')
				l_i := l_i + 1
			end
		end

end