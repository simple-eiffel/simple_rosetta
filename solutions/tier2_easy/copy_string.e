note
	description: "[
		Rosetta Code: Copy a string
		https://rosettacode.org/wiki/Copy_a_string

		Copy a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Copy_a_string"
	tier: "2"

class
	COPY_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string copying.
		local
			l_original, l_copy1, l_copy2: STRING
		do
			print ("Copy a String%N")
			print ("=============%N%N")

			l_original := "Hello, World!"

			-- Method 1: twin (deep copy)
			l_copy1 := l_original.twin
			print ("Original: '" + l_original + "'%N")
			print ("Twin copy: '" + l_copy1 + "'%N")

			-- Modify copy to prove independence
			l_copy1.append ("!!!")
			print ("After modifying copy:%N")
			print ("  Original: '" + l_original + "'%N")
			print ("  Copy: '" + l_copy1 + "'%N%N")

			-- Method 2: substring of entire string
			l_copy2 := l_original.substring (1, l_original.count)
			print ("Substring copy: '" + l_copy2 + "'%N")

			-- Reference vs copy
			print ("%NReference equality (l_original = l_copy2): " + (l_original = l_copy2).out + "%N")
			print ("Value equality (same_string): " + l_original.same_string (l_copy2).out + "%N")
		end

feature -- Operations

	copy_string (a_str: STRING): STRING
			-- Create independent copy.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
		ensure
			result_exists: Result /= Void
			equal_content: Result.same_string (a_str)
			different_object: Result /= a_str
		end

end