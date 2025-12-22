note
	description: "Client for Rosetta Code MediaWiki API"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ROSETTA_CLIENT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize client with default settings.
		do
			create json_parser
			create wiki_parser
			create last_error.make_empty
			requests_made := 0
		ensure
			no_error: not has_error
		end

feature -- Access

	last_error: STRING
			-- Last error message, empty if no error

	requests_made: INTEGER
			-- Number of API requests made

feature -- Status

	has_error: BOOLEAN
			-- Did the last operation produce an error?
		do
			Result := not last_error.is_empty
		end

feature -- API Operations

	fetch_all_task_names: ARRAYED_LIST [ROSETTA_TASK]
			-- Fetch all task names from Rosetta Code.
		local
			continue_token: detachable STRING
			batch: ARRAYED_LIST [ROSETTA_TASK]
			done: BOOLEAN
		do
			create Result.make (1500)
			last_error.wipe_out

			from done := False until done loop
				batch := fetch_task_batch (continue_token)
				if has_error then
					done := True
				elseif batch.is_empty then
					done := True
				else
					Result.append (batch)
					continue_token := last_continue_token
					if continue_token = Void then
						done := True
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

	fetch_task_content (task_name: STRING): detachable STRING
			-- Fetch raw wiki content for 'task_name'.
		require
			name_not_empty: not task_name.is_empty
		local
			url: STRING
			encoded_name: STRING
		do
			last_error.wipe_out
			encoded_name := url_encode (task_name)
			url := Raw_content_url + encoded_name

			wait_for_rate_limit
			Result := curl_get (url)
			if Result /= Void and then not Result.is_empty then
				requests_made := requests_made + 1
			end
		end

	fetch_task_with_solutions (task_name: STRING): detachable ROSETTA_TASK
			-- Fetch task and all its solutions.
		require
			name_not_empty: not task_name.is_empty
		local
			content: detachable STRING
			solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			i: INTEGER
		do
			content := fetch_task_content (task_name)
			if attached content as c and then not c.is_empty then
				create Result.make (task_name)
				Result.set_description (wiki_parser.extract_description (c))

				solutions := wiki_parser.extract_solutions (c)
				from i := 1 until i > solutions.count loop
					if attached {STRING} solutions.i_th (i).language as lang then
						Result.add_language (lang)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	fetch_task_batch (continue_token: detachable STRING): ARRAYED_LIST [ROSETTA_TASK]
			-- Fetch a batch of up to 500 tasks.
		local
			url: STRING
			json_value: detachable SIMPLE_JSON_VALUE
			response: detachable STRING
		do
			create Result.make (500)
			last_continue_token := Void
			last_error.wipe_out

			url := Api_endpoint + "?action=query&list=categorymembers"
			url.append ("&cmtitle=Category:Programming_Tasks")
			url.append ("&cmlimit=500&format=json")

			if attached continue_token as ct then
				url.append ("&cmcontinue=")
				url.append (url_encode (ct))
			end

			wait_for_rate_limit
			response := curl_get (url)

			if attached response as r and then not r.is_empty then
				requests_made := requests_made + 1
				json_value := json_parser.parse (r.to_string_32)
				if attached json_value then
					Result := parse_task_batch (json_value)
				else
					last_error := "Failed to parse JSON response"
				end
			else
				last_error := "Failed to fetch from Rosetta Code API"
			end
		end

	parse_task_batch (json: SIMPLE_JSON_VALUE): ARRAYED_LIST [ROSETTA_TASK]
			-- Parse task batch from API 'json' response.
		local
			task: ROSETTA_TASK
			members: detachable SIMPLE_JSON_ARRAY
			member: SIMPLE_JSON_VALUE
			i: INTEGER
			root_obj, member_obj: detachable SIMPLE_JSON_OBJECT
		do
			create Result.make (500)

			if json.is_object then
				root_obj := json.as_object

				-- Extract continue token if present
				if attached root_obj.object_item ("continue") as cont then
					if attached cont.string_item ("cmcontinue") as cm then
						last_continue_token := safe_to_string_8 (cm)
					end
				end

				-- Extract tasks from query.categorymembers
				if attached root_obj.object_item ("query") as query then
					members := query.array_item ("categorymembers")
					if attached members as mems then
						from i := 1 until i > mems.count loop
							member := mems.item (i)
							if member.is_object then
								member_obj := member.as_object
								if attached member_obj.string_item ("title") as title_val then
									if attached member_obj.string_item ("pageid") as pid then
										create task.make_from_api (safe_to_string_8 (title_val), safe_to_string_8 (pid))
									else
										create task.make (safe_to_string_8 (title_val))
									end
									Result.extend (task)
								end
							end
							i := i + 1
						end
					end
				end
			end
		end

	curl_get (a_url: STRING): detachable STRING
			-- Fetch URL content using curl command (supports HTTPS).
		local
			proc: SIMPLE_PROCESS
			cmd: STRING
			l_output: STRING_32
		do
			create proc.make
				-- Use cmd /c (same pattern as simple_process tests)
			cmd := "cmd /c curl -s %"" + a_url + "%""
			l_output := proc.output_of_command (cmd)

			if proc.was_successful and then not l_output.is_empty then
				Result := safe_to_string_8 (l_output)
			elseif not proc.was_successful then
				last_error := "curl failed: exit=" + proc.exit_code.out
			end
		end

	wait_for_rate_limit
			-- Wait to respect rate limiting (1 request/second).
		do
			execution_environment.sleep (1_000_000_000)
		end

	url_encode (s: STRING): STRING
			-- URL encode 's'.
		do
			Result := s.twin
			Result.replace_substring_all (" ", "_")
		end

	safe_to_string_8 (s: READABLE_STRING_32): STRING
			-- Convert STRING_32 to STRING_8, replacing non-ASCII with '?'.
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (s.count)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c.natural_32_code <= 127 then
					Result.append_character (c.to_character_8)
				else
					Result.append_character ('?')
				end
				i := i + 1
			end
		end

	last_continue_token: detachable STRING
			-- Continue token from last API call

feature {NONE} -- Implementation objects

	json_parser: SIMPLE_JSON
			-- JSON parser

	wiki_parser: WIKI_PARSER
			-- Wiki markup parser

	execution_environment: EXECUTION_ENVIRONMENT
			-- For sleep/delay
		once
			create Result
		end

feature {NONE} -- Constants

	Api_endpoint: STRING = "https://rosettacode.org/w/api.php"
			-- MediaWiki API endpoint

	Raw_content_url: STRING = "https://rosettacode.org/w/index.php?action=raw&title="
			-- URL for raw wiki content

end
