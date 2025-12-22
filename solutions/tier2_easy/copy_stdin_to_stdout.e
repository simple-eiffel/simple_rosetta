note
	description: "[
		Rosetta Code: Copy stdin to stdout
		https://rosettacode.org/wiki/Copy_stdin_to_stdout

		Read from standard input and write to standard output.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Copy_stdin_to_stdout"

class
	COPY_STDIN_TO_STDOUT

create
	make

feature {NONE} -- Initialization

	make
			-- Copy standard input to standard output.
		do
			-- Read line by line and echo
			from until io.input.end_of_file loop
				io.input.read_line
				io.output.put_string (io.input.last_string)
				io.output.put_new_line
			end

			-- Alternative: read character by character
			-- from until io.input.end_of_file loop
			--     io.input.read_character
			--     io.output.put_character (io.input.last_character)
			-- end
		end

end
