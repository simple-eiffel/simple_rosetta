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
			l_continue_token: detachable STRING
			l_batch: ARRAYED_LIST [ROSETTA_TASK]
			l_done: BOOLEAN
		do
			create Result.make (1500)
			last_error.wipe_out

			from l_done := False until l_done loop
				l_batch := fetch_task_batch (l_continue_token)
				if has_error then
					l_done := True
				elseif l_batch.is_empty then
					l_done := True
				else
					Result.append (l_batch)
					l_continue_token := last_continue_token
					if l_continue_token = Void then
						l_done := True
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

	fetch_task_content (a_task_name: STRING): detachable STRING
			-- Fetch raw wiki content for 'task_name'.
		require
			name_not_empty: not a_task_name.is_empty
		local
			l_url: STRING
			l_encoded_name: STRING
		do
			last_error.wipe_out
			l_encoded_name := url_encode (a_task_name)
			l_url := Raw_content_url + l_encoded_name

			wait_for_rate_limit
			Result := curl_get (l_url)
			if Result /= Void and then not Result.is_empty then
				requests_made := requests_made + 1
			end
		end

	fetch_task_with_solutions (a_task_name: STRING): detachable ROSETTA_TASK
			-- Fetch task and all its solutions.
		require
			name_not_empty: not a_task_name.is_empty
		local
			l_content: detachable STRING
			l_solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			i: INTEGER
		do
			l_content := fetch_task_content (a_task_name)
			if attached l_content as c and then not c.is_empty then
				create Result.make (a_task_name)
				Result.set_description (wiki_parser.extract_description (c))

				l_solutions := wiki_parser.extract_solutions (c)
				from i := 1 until i > l_solutions.count loop
					if attached {STRING} l_solutions.i_th (i).language as al_lang then
						Result.add_language (al_lang)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	fetch_task_batch (a_continue_token: detachable STRING): ARRAYED_LIST [ROSETTA_TASK]
			-- Fetch a batch of up to 500 tasks.
		local
			l_url: STRING
			l_json_value: detachable SIMPLE_JSON_VALUE
			l_response: detachable STRING
		do
			create Result.make (500)
			last_continue_token := Void
			last_error.wipe_out

			l_url := Api_endpoint + "?action=query&list=categorymembers"
			l_url.append ("&cmtitle=Category:Programming_Tasks")
			l_url.append ("&cmlimit=500&format=json")

			if attached a_continue_token as al_ct then
				l_url.append ("&cmcontinue=")
				l_url.append (url_encode (al_ct))
			end

			wait_for_rate_limit
			l_response := curl_get (l_url)

			if attached l_response as r and then not r.is_empty then
				requests_made := requests_made + 1
				l_json_value := json_parser.parse (r.to_string_32)
				if attached l_json_value then
					Result := parse_task_batch (l_json_value)
				else
					last_error := "Failed to parse JSON response"
				end
			else
				last_error := "Failed to fetch from Rosetta Code API"
			end
		end

	parse_task_batch (a_json: SIMPLE_JSON_VALUE): ARRAYED_LIST [ROSETTA_TASK]
			-- Parse task batch from API 'json' response.
		local
			l_task: ROSETTA_TASK
			l_members: detachable SIMPLE_JSON_ARRAY
			l_member: SIMPLE_JSON_VALUE
			i: INTEGER
			root_obj, member_obj: detachable SIMPLE_JSON_OBJECT
		do
			create Result.make (500)

			if a_json.is_object then
				root_obj := a_json.as_object

				-- Extract continue token if present
				if attached root_obj.object_item ("continue") as al_cont then
					if attached al_cont.string_item ("cmcontinue") as al_cm then
						last_continue_token := safe_to_string_8 (al_cm)
					end
				end

				-- Extract tasks from query.categorymembers
				if attached root_obj.object_item ("query") as al_query then
					l_members := al_query.array_item ("categorymembers")
					if attached l_members as al_mems then
						from i := 1 until i > al_mems.count loop
							l_member := al_mems.item (i)
							if l_member.is_object then
								member_obj := l_member.as_object
								if attached member_obj.string_item ("title") as al_title_val then
									if attached member_obj.string_item ("pageid") as al_pid then
										create l_task.make_from_api (safe_to_string_8 (al_title_val), safe_to_string_8 (al_pid))
									else
										create l_task.make (safe_to_string_8 (al_title_val))
									end
									Result.extend (l_task)
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
			l_proc: SIMPLE_PROCESS
			l_cmd: STRING
			l_output: STRING_32
		do
			create l_proc.make
				-- Use cmd /c (same pattern as simple_process tests)
			l_cmd := "cmd /c curl -s %"" + a_url + "%""
			l_output := l_proc.output_of_command (l_cmd)

			if l_proc.was_successful and then not l_output.is_empty then
				Result := safe_to_string_8 (l_output)
			elseif not l_proc.was_successful then
				last_error := "curl failed: exit=" + l_proc.exit_code.out
			end
		end

	wait_for_rate_limit
			-- Wait to respect rate limiting (1 request/second).
		do
			execution_environment.sleep (1_000_000_000)
		end

	url_encode (a_s: STRING): STRING
			-- URL encode 's'.
		do
			Result := a_s.twin
			Result.replace_substring_all (" ", "_")
		end

	safe_to_string_8 (a_s: READABLE_STRING_32): STRING
			-- Convert STRING_32 to STRING_8, replacing non-ASCII with '?'.
		local
			i: INTEGER
			c: CHARACTER_32
		do
			create Result.make (a_s.count)
			from i := 1 until i > a_s.count loop
				c := a_s.item (i)
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
