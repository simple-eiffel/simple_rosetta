note
	description: "[
		Rosetta Code: Hello world/Text
		https://rosettacode.org/wiki/Hello_world/Text
		
		Display 'Hello World' as text.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Hello_world/Text"

class
	HELLO_TEXT

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("Hello, World!%N")
		end

end
