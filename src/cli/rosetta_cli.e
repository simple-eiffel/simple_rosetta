note
	description: "Rosetta Code CLI tool for managing Eiffel solutions."
	author: "Simple Eiffel"
	date: "$Date$"

class
	ROSETTA_CLI

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run CLI with command line arguments.
		do
			create store.make ("rosetta_solutions.db")
			create validator.make

			if argument_count = 0 then
				show_help
			else
				process_command
			end

			store.close
		end

feature -- Commands

	process_command
			-- Process the command line arguments.
		local
			cmd: STRING_32
		do
			cmd := argument (1)
			if cmd.same_string ("wiki") then
				cmd_wiki
			elseif cmd.same_string ("search") then
				cmd_search
			elseif cmd.same_string ("list") then
				cmd_list
			elseif cmd.same_string ("missing") then
				cmd_missing
			elseif cmd.same_string ("validate") then
				cmd_validate
			elseif cmd.same_string ("stats") then
				cmd_stats
			elseif cmd.same_string ("help") or cmd.same_string ("--help") or cmd.same_string ("-h") then
				show_help
			else
				print ("Unknown command: " + cmd.to_string_8 + "%N")
				show_help
			end
		end

	cmd_wiki
			-- Generate wiki format for a task.
		local
			task_name: STRING
			wiki: detachable STRING
		do
			if argument_count < 2 then
				print ("Usage: rosetta wiki <task_name>%N")
				print ("Example: rosetta wiki Fibonacci_sequence%N")
			else
				task_name := argument (2).to_string_8
				wiki := store.solution_as_wiki (task_name)
				if attached wiki as w then
					print (w)
					print ("%N%N-- Copy the above to Rosetta Code wiki --%N")
				else
					print ("Solution not found: " + task_name + "%N")
					print ("Use 'rosetta search " + task_name + "' to find similar tasks%N")
				end
			end
		end

	cmd_search
			-- Search for solutions.
		local
			keyword: STRING
			results: ARRAYED_LIST [TUPLE [task: STRING; tier: INTEGER; class_name: STRING]]
			i: INTEGER
		do
			if argument_count < 2 then
				print ("Usage: rosetta search <keyword>%N")
				print ("Example: rosetta search sort%N")
			else
				keyword := argument (2).to_string_8
				results := store.search_solutions (keyword)
				if results.is_empty then
					print ("No solutions found for: " + keyword + "%N")
				else
					print ("Found " + results.count.out + " solutions for '" + keyword + "':%N%N")
					from i := 1 until i > results.count loop
						print ("  [TIER " + results.i_th (i).tier.out + "] " + results.i_th (i).task + "%N")
						i := i + 1
					end
				end
			end
		end

	cmd_list
			-- List solutions by tier.
		local
			tier: INTEGER
			solutions: ARRAYED_LIST [TUPLE [task: STRING; class_name: STRING; file: STRING]]
			i: INTEGER
		do
			if argument_count >= 2 and then argument (2).is_integer then
				tier := argument (2).to_integer
				if tier >= 1 and tier <= 4 then
					solutions := store.solutions_by_tier (tier)
					print ("TIER " + tier.out + " Solutions (" + solutions.count.out + "):%N%N")
					from i := 1 until i > solutions.count loop
						print ("  " + solutions.i_th (i).task + "%N")
						i := i + 1
					end
				else
					print ("Invalid tier. Use 1-4.%N")
				end
			else
				-- List all tiers
				print ("All Solutions by Tier:%N%N")
				show_tier_summary
			end
		end

	cmd_missing
			-- Show tasks missing Eiffel solutions.
		local
			easy_only: BOOLEAN
		do
			easy_only := argument_count >= 2 and then
				(argument (2).same_string ("--easy") or argument (2).same_string ("-e"))

			if easy_only then
				show_easy_missing
			else
				show_all_missing
			end
		end

	cmd_validate
			-- Validate solutions compile correctly.
		local
			task_name: STRING
		do
			if argument_count >= 2 then
				task_name := argument (2).to_string_8
				validate_single (task_name)
			else
				validate_all
			end
		end

	cmd_stats
			-- Show solution statistics.
		do
			print ("=== Rosetta Code Eiffel Solutions ===%N%N")
			print ("Total Solutions: " + store.solution_count.out + "%N%N")
			show_tier_summary
		end

feature {NONE} -- Implementation

	show_help
			-- Display help message.
		do
			print ("Rosetta Code CLI - Manage Eiffel solutions%N%N")
			print ("Commands:%N")
			print ("  wiki <task>      Generate wiki-ready format for submission%N")
			print ("  search <keyword> Search solutions by keyword%N")
			print ("  list [tier]      List solutions (optionally by tier 1-4)%N")
			print ("  missing [--easy] Show tasks without Eiffel solutions%N")
			print ("  validate [task]  Validate solutions compile correctly%N")
			print ("  stats            Show solution statistics%N")
			print ("  help             Show this help%N%N")
			print ("Examples:%N")
			print ("  rosetta wiki Fibonacci_sequence%N")
			print ("  rosetta search sort%N")
			print ("  rosetta list 1%N")
			print ("  rosetta missing --easy%N")
			print ("  rosetta validate%N")
		end

	show_tier_summary
			-- Display tier summary.
		local
			summary: ARRAYED_LIST [TUPLE [tier: INTEGER; solution_count: INTEGER]]
			i: INTEGER
		do
			summary := store.tier_summary
			from i := 1 until i > summary.count loop
				print ("  TIER " + summary.i_th (i).tier.out + ": " + summary.i_th (i).solution_count.out + " solutions%N")
				i := i + 1
			end
		end

	show_easy_missing
			-- Show easy missing tasks from Quick Wins guide.
		do
			print ("Easy Missing Tasks (from Quick Wins guide):%N%N")
			print ("See: D:/prod/simple_rosetta/reports/QUICK_WINS.md%N")
			print ("%NCategories with easiest tasks:%N")
			print ("  1. Empty Program - just create empty class%N")
			print ("  2. Hello World variants - simple print statements%N")
			print ("  3. Boolean/Logic - basic operations%N")
			print ("  4. String basics - length, concat, case%N")
			print ("  5. Array basics - create, access, length%N")
		end

	show_all_missing
			-- Show all missing tasks count.
		do
			print ("Missing Eiffel Solutions:%N%N")
			print ("Total Rosetta Code tasks: ~1,339%N")
			print ("Tasks with Eiffel: ~157 (12%%)%N")
			print ("Tasks without Eiffel: ~1,182 (88%%)%N%N")
			print ("Use 'rosetta missing --easy' for quick wins%N")
			print ("See: D:/prod/simple_rosetta/reports/MISSING_EIFFEL_TASKS.md%N")
		end

	validate_single (a_task: STRING)
			-- Validate a single solution.
		local
			code: detachable STRING
		do
			code := store.get_solution_code (a_task)
			if attached code as c then
				print ("Validating: " + a_task + "%N")
				if validator.validate_code (c) then
					print ("  [PASS] Solution compiles correctly%N")
				else
					print ("  [FAIL] " + validator.last_error + "%N")
				end
			else
				print ("Solution not found: " + a_task + "%N")
			end
		end

	validate_all
			-- Validate all solutions.
		local
			summary: ARRAYED_LIST [TUPLE [tier: INTEGER; solution_count: INTEGER]]
			solutions: ARRAYED_LIST [TUPLE [task: STRING; class_name: STRING; file: STRING]]
			i, j, passed, failed: INTEGER
		do
			print ("Validating all solutions...%N%N")
			passed := 0
			failed := 0
			summary := store.tier_summary

			from i := 1 until i > summary.count loop
				print ("TIER " + summary.i_th (i).tier.out + ":%N")
				solutions := store.solutions_by_tier (summary.i_th (i).tier)
				from j := 1 until j > solutions.count loop
					if validator.validate_file (solutions.i_th (j).file) then
						print ("  [PASS] " + solutions.i_th (j).task + "%N")
						passed := passed + 1
					else
						print ("  [FAIL] " + solutions.i_th (j).task + ": " + validator.last_error + "%N")
						failed := failed + 1
					end
					j := j + 1
				end
				i := i + 1
			end

			print ("%N=== Validation Complete ===%N")
			print ("Passed: " + passed.out + "%N")
			print ("Failed: " + failed.out + "%N")
		end

feature {NONE} -- Attributes

	store: SOLUTION_STORE
			-- Solution database

	validator: SOLUTION_VALIDATOR
			-- Code validator

end
