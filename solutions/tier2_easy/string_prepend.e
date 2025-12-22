note
	description: "[
		Rosetta Code: String prepend
		https://rosettacode.org/wiki/String_prepend

		Prepend one string to another.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_prepend"
	tier: "2"

class
	STRING_PREPEND

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string prepending.
		local
			l_str: STRING
		do
			print ("String Prepend%N")
			print ("==============%N%N")

			-- Using prepend
			l_str := "World!"
			l_str.prepend ("Hello, ")
			print ("Using prepend: " + l_str + "%N")

			-- Using concatenation
			l_str := "Hello, " + "World!"
			print ("Using '+': " + l_str + "%N")

			-- Prepend character
			l_str := "ello"
			l_str.prepend_character ('H')
			print ("Prepend char: " + l_str + "%N")
		end

feature -- Operations

	prepend (a_base, a_prefix: STRING): STRING
			-- Create new string with prefix.
		require
			base_exists: a_base /= Void
			prefix_exists: a_prefix /= Void
		do
			Result := a_prefix + a_base
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = a_base.count + a_prefix.count
		end

	prepend_in_place (a_str, a_prefix: STRING)
			-- Prepend prefix to string in place.
		require
			str_exists: a_str /= Void
			prefix_exists: a_prefix /= Void
		do
			a_str.prepend (a_prefix)
		end

end