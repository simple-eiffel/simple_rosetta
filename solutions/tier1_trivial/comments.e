note
	description: "[
		Rosetta Code: Comments
		https://rosettacode.org/wiki/Comments
		
		Demonstrate comment syntax in Eiffel.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Comments"

class
	COMMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Eiffel comment syntax.
		do
			-- This is a single-line comment

			print ("Hello, World!%N")  -- End-of-line comment

			-- Eiffel does not have multi-line comment syntax.
			-- Instead, use multiple single-line comments
			-- like this block of text.

			-- Note: Eiffel uses "note" clause for documentation
			-- which is not a comment but metadata.

			print ("Comments demonstrated.%N")
		end

end
