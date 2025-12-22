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
			-- Scan tasks to find Eiffel solutions.
		local
			client: ROSETTA_CLIENT
			parser: WIKI_PARSER
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			content: detachable STRING
			eiffel_code: detachable STRING
			i, scan_limit, eiffel_found: INTEGER
			with_eiffel, without_eiffel: ARRAYED_LIST [STRING]
		do
			print ("=== Eiffel Focus Scan ===%N%N")

			create client.make
			create parser
			create with_eiffel.make (50)
			create without_eiffel.make (100)

			-- Step 1: Get all task names
			print ("Step 1: Fetching task list...%N")
			tasks := client.fetch_all_task_names

			if client.has_error then
				print ("  ERROR: " + client.last_error + "%N")
			else
				print ("  Found " + tasks.count.out + " total tasks%N%N")

				-- Step 2: Scan first N tasks for Eiffel
				scan_limit := 50  -- Scan 50 tasks (~50 seconds with rate limiting)
				print ("Step 2: Scanning first " + scan_limit.out + " tasks for Eiffel...%N")

				from i := 1 until i > scan_limit.min (tasks.count) loop
					print ("  [" + i.out + "/" + scan_limit.out + "] " + tasks.i_th (i).name)

					content := client.fetch_task_content (tasks.i_th (i).name)

					if attached content as c and then not c.is_empty then
						if parser.has_eiffel (c) then
							with_eiffel.extend (tasks.i_th (i).name)
							eiffel_found := eiffel_found + 1
							print (" -> EIFFEL!%N")

							-- Extract and show first line of Eiffel code
							eiffel_code := parser.extract_eiffel_solution (c)
							if attached eiffel_code as ec and then not ec.is_empty then
								print ("      Code: " + ec.substring (1, ec.count.min (50)) + "...%N")
							end
						else
							without_eiffel.extend (tasks.i_th (i).name)
							print ("%N")
						end
					else
						without_eiffel.extend (tasks.i_th (i).name)
						print (" (no content)%N")
					end

					i := i + 1
				end

				-- Step 3: Report
				print ("%N=== Eiffel Scan Results ===%N")
				print ("Scanned: " + scan_limit.out + " tasks%N")
				print ("With Eiffel: " + eiffel_found.out + " (" + ((eiffel_found * 100) // scan_limit).out + "%%)%N")
				print ("Without Eiffel: " + without_eiffel.count.out + "%N%N")

				-- List tasks with Eiffel
				if eiffel_found > 0 then
					print ("Tasks with Eiffel solutions:%N")
					from i := 1 until i > with_eiffel.count loop
						print ("  " + i.out + ". " + with_eiffel.i_th (i) + "%N")
						i := i + 1
					end
				end

				-- Estimate total
				print ("%NEstimate: ~" + ((eiffel_found * tasks.count) // scan_limit).out + " tasks have Eiffel (of " + tasks.count.out + " total)%N")
			end
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
