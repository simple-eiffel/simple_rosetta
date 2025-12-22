note
	description: "[
		Rosetta Code: Read a file line by line
		https://rosettacode.org/wiki/Read_a_file_line_by_line

		Read and print each line of a file.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Read_a_file_line_by_line"

class
	READ_FILE_LINE_BY_LINE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate line-by-line file reading.
		local
			file: PLAIN_TEXT_FILE
			line_number: INTEGER
		do
			create file.make_with_name ("input.txt")

			if file.exists and then file.is_readable then
				file.open_read

				print ("Contents of input.txt:%N")
				print ("=====================%N")

				from
					line_number := 1
				until
					file.end_of_file
				loop
					file.read_line
					print (line_number.out + ": " + file.last_string + "%N")
					line_number := line_number + 1
				end

				file.close
				print ("=====================%N")
				print ("Total lines: " + (line_number - 1).out + "%N")
			else
				print ("Cannot read file: input.txt%N")
			end
		end

end
