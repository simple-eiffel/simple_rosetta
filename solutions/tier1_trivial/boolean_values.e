note
	description: "[
		Rosetta Code: Boolean values
		https://rosettacode.org/wiki/Boolean_values

		Show how to represent boolean values in Eiffel.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Boolean_values"

class
	BOOLEAN_VALUES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate boolean values.
		local
			b1, b2: BOOLEAN
		do
			-- Boolean literals
			b1 := True
			b2 := False

			print ("Boolean values in Eiffel:%N")
			print ("  True literal: " + b1.out + "%N")
			print ("  False literal: " + b2.out + "%N")

			-- Boolean operations
			print ("%NBoolean operations:%N")
			print ("  True and False = " + (True and False).out + "%N")
			print ("  True or False = " + (True or False).out + "%N")
			print ("  not True = " + (not True).out + "%N")
			print ("  True xor False = " + (True xor False).out + "%N")
			print ("  True implies False = " + (True implies False).out + "%N")

			-- Default value
			print ("%NDefault BOOLEAN value: " + (create {BOOLEAN}).out + "%N")
		end

end
