note
	description: "[
		Rosetta Code: Delete a file
		https://rosettacode.org/wiki/Delete_a_file

		Delete a file and directory.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Delete_a_file"

class
	DELETE_FILE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate file and directory deletion.
		local
			file: RAW_FILE
			dir: DIRECTORY
		do
			-- Delete a file
			create file.make_with_name ("input.txt")
			if file.exists then
				file.delete
				print ("Deleted file: input.txt%N")
			else
				print ("File does not exist: input.txt%N")
			end

			-- Delete a directory (must be empty)
			create dir.make ("docs")
			if dir.exists then
				if dir.is_empty then
					dir.delete
					print ("Deleted directory: docs%N")
				else
					print ("Cannot delete non-empty directory: docs%N")
				end
			else
				print ("Directory does not exist: docs%N")
			end

			-- Recursive delete would require traversing directory
			print ("%NNote: Eiffel doesn't have built-in recursive delete%N")
			print ("Use DIRECTORY.entries to traverse and delete%N")
		end

end
