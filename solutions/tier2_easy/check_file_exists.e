note
	description: "[
		Rosetta Code: Check that file exists
		https://rosettacode.org/wiki/Check_that_file_exists

		Check whether a file or directory exists.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Check_that_file_exists"

class
	CHECK_FILE_EXISTS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate file existence checking.
		local
			file: RAW_FILE
			dir: DIRECTORY
		do
			-- Check file existence
			create file.make_with_name ("input.txt")
			print ("input.txt exists: " + file.exists.out + "%N")

			create file.make_with_name ("docs/readme.txt")
			print ("docs/readme.txt exists: " + file.exists.out + "%N")

			-- Check directory existence
			create dir.make ("docs")
			print ("docs/ exists: " + dir.exists.out + "%N")

			create dir.make ("nonexistent")
			print ("nonexistent/ exists: " + dir.exists.out + "%N")

			-- Additional checks
			create file.make_with_name ("input.txt")
			if file.exists then
				print ("%NFile properties:%N")
				print ("  is_readable: " + file.is_readable.out + "%N")
				print ("  is_writable: " + file.is_writable.out + "%N")
				print ("  is_directory: " + file.is_directory.out + "%N")
			end
		end

end
