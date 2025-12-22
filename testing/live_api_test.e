note
	description: "Live API test for simple_rosetta - fetches real data from Rosetta Code"
	author: "Larry Rix"

class
	LIVE_API_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Run live API tests.
		do
			print ("=== simple_rosetta Live API Test ===%N%N")

			test_eiffel_scan

			print ("%N=== Live API Tests Complete ===%N")
		end

feature -- Tests

	test_eiffel_scan
			-- Scan ALL tasks for Eiffel solutions and store in database.
		local
			rosetta: SIMPLE_ROSETTA
			client: ROSETTA_CLIENT
			parser: WIKI_PARSER
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			task: ROSETTA_TASK
			solution: ROSETTA_SOLUTION
			content: detachable STRING
			eiffel_code: detachable STRING
			i, eiffel_found: INTEGER
			with_eiffel: ARRAYED_LIST [STRING]
			file: RAW_FILE
		do
			print ("=== Full Eiffel Scan + Store ===%N%N")

			-- Clean up old database
			create file.make_with_name ("eiffel_scan.db")
			if file.exists then
				file.delete
			end

			create rosetta.make_with_db ("eiffel_scan.db")
			create client.make
			create parser
			create with_eiffel.make (200)

			-- Step 1: Get all task names
			print ("Step 1: Fetching task list...%N")
			tasks := client.fetch_all_task_names

			if client.has_error then
				print ("  ERROR: " + client.last_error + "%N")
			else
				print ("  Found " + tasks.count.out + " total tasks%N%N")

				-- Step 2: Scan ALL tasks for Eiffel
				print ("Step 2: Scanning ALL " + tasks.count.out + " tasks for Eiffel...%N")
				print ("  (This will take ~25 minutes due to rate limiting)%N%N")

				from i := 1 until i > tasks.count loop
					print ("  [" + i.out + "/" + tasks.count.out + "] " + tasks.i_th (i).name)

					content := client.fetch_task_content (tasks.i_th (i).name)

					if attached content as c and then not c.is_empty then
						-- Create task record
						create task.make (tasks.i_th (i).name)
						task.set_description (parser.extract_description (c))

						if parser.has_eiffel (c) then
							with_eiffel.extend (tasks.i_th (i).name)
							task.add_language ("Eiffel")
							eiffel_found := eiffel_found + 1
							print (" -> EIFFEL! (" + eiffel_found.out + " total)%N")

							-- Extract and store Eiffel code
							eiffel_code := parser.extract_eiffel_solution (c)
							if attached eiffel_code as ec and then not ec.is_empty then
								-- Import full task to get solutions stored
								rosetta.import_task (task.name)
							end
						else
							print ("%N")
						end
					else
						print (" (no content)%N")
					end

					i := i + 1
				end

				-- Step 3: Report
				print ("%N=== FULL EIFFEL SCAN RESULTS ===%N")
				print ("Total tasks scanned: " + tasks.count.out + "%N")
				print ("Tasks with Eiffel: " + eiffel_found.out + " (" + ((eiffel_found * 100) // tasks.count).out + "%%)%N")
				print ("Tasks without Eiffel: " + (tasks.count - eiffel_found).out + "%N%N")

				-- List all tasks with Eiffel
				print ("Complete list of tasks with Eiffel solutions:%N")
				from i := 1 until i > with_eiffel.count loop
					print ("  " + i.out + ". " + with_eiffel.i_th (i) + "%N")
					i := i + 1
				end

				-- Database stats
				print ("%N" + rosetta.stats + "%N")
			end

			rosetta.close
		end

	test_fetch_task_list
			-- Test fetching task list from API.
		local
			client: ROSETTA_CLIENT
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			i, max_display: INTEGER
		do
			print ("Test 1: Fetch task list from Rosetta Code API%N")
			print ("  Connecting to rosettacode.org...%N")

			create client.make

			-- Fetch first batch (up to 500 tasks)
			tasks := client.fetch_all_task_names

			if client.has_error then
				print ("  ERROR: " + client.last_error + "%N")
			else
				print ("  SUCCESS: Fetched " + tasks.count.out + " tasks%N")

				-- Display first 10
				max_display := tasks.count.min (10)
				print ("  First " + max_display.out + " tasks:%N")
				from i := 1 until i > max_display loop
					print ("    " + i.out + ". " + tasks.i_th (i).name + "%N")
					i := i + 1
				end
			end

			print ("%N")
		end

	test_fetch_task_with_solutions
			-- Test fetching a specific task with its solutions.
		local
			client: ROSETTA_CLIENT
			task: detachable ROSETTA_TASK
			task_names: ARRAY [STRING]
			name: STRING
			i: INTEGER
		do
			print ("Test 2: Fetch specific tasks with solutions%N")

			create client.make

			-- Test with well-known tasks
			task_names := <<"Hello world/Text", "Fibonacci sequence", "FizzBuzz">>

			from i := 1 until i > task_names.count loop
				name := task_names [i]
				print ("  Fetching: " + name + "...%N")

				task := client.fetch_task_with_solutions (name)

				if client.has_error then
					print ("    ERROR: " + client.last_error + "%N")
				elseif attached task as t then
					print ("    Languages: " + t.language_count.out)
					if t.has_eiffel then
						print (" (includes Eiffel)")
					end
					print ("%N")
					if not t.description.is_empty then
						print ("    Description: " + t.description.substring (1, t.description.count.min (80)) + "...%N")
					end
				else
					print ("    No task returned%N")
				end

				i := i + 1
			end

			print ("%N")
		end

	test_store_and_retrieve
			-- Test storing fetched tasks in database.
		local
			rosetta: SIMPLE_ROSETTA
			client: ROSETTA_CLIENT
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			i, max_store: INTEGER
			file: RAW_FILE
		do
			print ("Test 3: Store and retrieve tasks%N")

			-- Clean up old test database
			create file.make_with_name ("live_test.db")
			if file.exists then
				file.delete
			end

			create rosetta.make_with_db ("live_test.db")
			create client.make

			-- Fetch tasks
			print ("  Fetching task list...%N")
			tasks := client.fetch_all_task_names

			if client.has_error then
				print ("  ERROR fetching: " + client.last_error + "%N")
			else
				-- Store first 10 using import_task
				max_store := tasks.count.min (10)
				print ("  Importing first " + max_store.out + " tasks...%N")

				from i := 1 until i > max_store loop
					rosetta.import_task (tasks.i_th (i).name)
					if rosetta.has_error then
						print ("    ERROR: " + rosetta.last_error + "%N")
					else
						print ("    Imported: " + tasks.i_th (i).name + "%N")
					end
					i := i + 1
				end

				-- Verify
				print ("%N  Verification:%N")
				print (rosetta.stats)
			end

			-- Cleanup
			rosetta.close
			create file.make_with_name ("live_test.db")
			if file.exists then
				file.delete
			end

			print ("%N")
		end

end
