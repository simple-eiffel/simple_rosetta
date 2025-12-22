note
	description: "[
		Rosetta Code: Hello world/Graphical
		https://rosettacode.org/wiki/Hello_world/Graphical
		
		Display 'Hello World' in a graphical window.
		(Console simulation - Vision2 would be needed for GUI)
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Hello_world/Graphical"

class
	HELLO_GRAPHICAL

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate graphical output concept.
		do
			print ("+---------------------------+%N")
			print ("|                           |%N")
			print ("|      Hello, World!        |%N")
			print ("|                           |%N")
			print ("+---------------------------+%N")
			print ("%NNote: Full GUI would use EiffelVision2 library.%N")
		end

end
