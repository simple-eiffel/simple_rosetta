note
	description: "[
		Rosetta Code: Empty string
		https://rosettacode.org/wiki/Empty_string

		Demonstrate creation and detection of empty strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Empty_string"
	tier: "1"

class
	EMPTY_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate empty string operations.
		local
			l_empty, l_non_empty: STRING
		do
			print ("Empty String%N")
			print ("============%N%N")

			-- Create empty string
			create l_empty.make_empty
			l_non_empty := "Hello"

			print ("Empty string: '" + l_empty + "'%N")
			print ("  is_empty: " + l_empty.is_empty.out + "%N")
			print ("  count: " + l_empty.count.out + "%N%N")

			print ("Non-empty string: '" + l_non_empty + "'%N")
			print ("  is_empty: " + l_non_empty.is_empty.out + "%N")
			print ("  count: " + l_non_empty.count.out + "%N%N")

			-- Alternative empty string creation
			l_empty := ""
			print ("Literal empty string '': is_empty = " + l_empty.is_empty.out + "%N")
		end

feature -- Query

	is_empty (a_str: STRING): BOOLEAN
			-- Is `a_str' empty?
		require
			str_exists: a_str /= Void
		do
			Result := a_str.is_empty
		end

	is_blank (a_str: STRING): BOOLEAN
			-- Is `a_str' empty or only whitespace?
		require
			str_exists: a_str /= Void
		local
			l_trimmed: STRING
		do
			l_trimmed := a_str.twin
			l_trimmed.left_adjust
			l_trimmed.right_adjust
			Result := l_trimmed.is_empty
		end

end