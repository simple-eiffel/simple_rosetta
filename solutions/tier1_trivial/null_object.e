note
	description: "[
		Rosetta Code: Null object
		https://rosettacode.org/wiki/Null_object
		
		Demonstrate null/void handling.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Null_object"

class
	NULL_OBJECT

create
	make

feature {NONE} -- Initialization

	make
		local
			s: detachable STRING
			t: STRING
		do
			-- In Eiffel, detachable types can be Void (null)
			s := Void
			
			if s = Void then
				print ("s is Void (null)%N")
			end
			
			-- Attached types are never Void
			t := "Hello"
			print ("t is attached: " + t + "%N")
			
			-- Safe access with attached check
			s := "World"
			if attached s as attached_s then
				print ("s is now: " + attached_s + "%N")
			end
		end

end
