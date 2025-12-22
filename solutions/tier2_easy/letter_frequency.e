note
	description: "[
		Rosetta Code: Letter frequency
		https://rosettacode.org/wiki/Letter_frequency
		
		Count frequency of each letter in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Letter_frequency"

class
	LETTER_FREQUENCY

create
	make

feature {NONE} -- Initialization

	make
		local
			text: STRING
			freq: HASH_TABLE [INTEGER, CHARACTER]
			c: CHARACTER
			i: INTEGER
		do
			text := "Hello, World! This is a test of letter frequency."
			text.to_lower
			
			create freq.make (26)
			
			from i := 1 until i > text.count loop
				c := text.item (i)
				if c.is_alpha then
					if freq.has (c) then
						freq.force (freq.item (c) + 1, c)
					else
						freq.put (1, c)
					end
				end
				i := i + 1
			end
			
			print ("Letter frequencies:%N")
			from freq.start until freq.after loop
				print ("  " + freq.key_for_iteration.out + ": " + freq.item_for_iteration.out + "%N")
				freq.forth
			end
		end

end
