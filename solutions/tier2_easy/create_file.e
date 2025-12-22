note
	description: "[
		Rosetta Code: Create a file
		https://rosettacode.org/wiki/Create_a_file

		Create a new empty file and directory.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Create_a_file"

class
	CREATE_FILE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate file and directory creation.
		local
			file: PLAIN_TEXT_FILE
			dir: DIRECTORY
		do
			-- Create a file in current directory
			create file.make_create_read_write ("output.txt")
			file.put_string ("Hello, World!")
			file.close
			print ("Created file: output.txt%N")

			-- Create a directory
			create dir.make ("docs")
			if not dir.exists then
				dir.create_dir
				print ("Created directory: docs%N")
			else
				print ("Directory already exists: docs%N")
			end

			-- Create a file in the new directory
			create file.make_create_read_write ("docs/readme.txt")
			file.put_string ("This is a readme file.")
			file.close
			print ("Created file: docs/readme.txt%N")

			-- Create file in root (Unix) or C:\ (Windows)
			-- Note: May require elevated privileges
			print ("%NNote: Creating files in root requires appropriate permissions%N")
		end

end
