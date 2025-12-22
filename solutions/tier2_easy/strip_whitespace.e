note
	description: "[
		Rosetta Code: Strip whitespace from a string/Top and tail
		https://rosettacode.org/wiki/Strip_whitespace_from_a_string/Top_and_tail
		
		Remove leading/trailing whitespace from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Strip_whitespace_from_a_string/Top_and_tail"

class
	STRIP_WHITESPACE

create
	make

feature {NONE} -- Initialization

	make
		local
			s: STRING
		do
			s := "   Hello, World!   "
			print ("Original: [" + s + "]%N")
			
			-- Left trim
			s := "   Hello, World!   "
			s.left_adjust
			print ("Left trimmed: [" + s + "]%N")
			
			-- Right trim
			s := "   Hello, World!   "
			s.right_adjust
			print ("Right trimmed: [" + s + "]%N")
			
			-- Both sides
			s := "   Hello, World!   "
			s.adjust
			print ("Both trimmed: [" + s + "]%N")
		end

end
