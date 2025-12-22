note
	description: "[
		Rosetta Code: Rename a file
		https://rosettacode.org/wiki/Rename_a_file

		Rename a file and directory.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Rename_a_file"

class
	RENAME_FILE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate file renaming.
		local
			file: RAW_FILE
			dir: DIRECTORY
		do
			-- Rename a file
			create file.make_with_name ("input.txt")
			if file.exists then
				file.rename_file ("output.txt")
				print ("Renamed input.txt to output.txt%N")
			else
				print ("File does not exist: input.txt%N")
			end

			-- Rename a directory
			create dir.make ("docs")
			if dir.exists then
				dir.rename_path (create {PATH}.make_from_string ("documentation"))
				print ("Renamed docs to documentation%N")
			else
				print ("Directory does not exist: docs%N")
			end

			-- Note: rename_file can also move files
			print ("%NNote: rename_file can move files to different directories%N")
		end

end
