note
	description: "[
		Rosetta Code: Copy a string
		https://rosettacode.org/wiki/Copy_a_string

		Demonstrate how to copy a string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Copy_a_string"

class
	COPY_A_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string copying.
		local
			original, copy1, copy2, copy3: STRING
		do
			original := "Hello, World!"
			print ("Original: %"" + original + "%"%N")

			-- Method 1: twin (creates independent copy)
			copy1 := original.twin
			print ("copy1 := original.twin%N")

			-- Method 2: make_from_string
			create copy2.make_from_string (original)
			print ("create copy2.make_from_string (original)%N")

			-- Method 3: copy procedure (copies content)
			create copy3.make_empty
			copy3.copy (original)
			print ("copy3.copy (original)%N")

			-- Prove they're independent
			copy1.append (" [modified]")
			print ("%NAfter modifying copy1:%N")
			print ("  original: %"" + original + "%"%N")
			print ("  copy1: %"" + copy1 + "%"%N")
			print ("  copy2: %"" + copy2 + "%"%N")
			print ("  copy3: %"" + copy3 + "%"%N")
		end

end
