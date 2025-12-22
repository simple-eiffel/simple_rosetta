note
	description: "[
		Rosetta Code: Depth-first search
		https://rosettacode.org/wiki/Depth-first_search

		Implement DFS for graph traversal.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Depth-first_search"

class
	DEPTH_FIRST_SEARCH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate depth-first search.
		local
			graph: ARRAY [ARRAYED_LIST [INTEGER]]
			visited: ARRAY [BOOLEAN]
			found: BOOLEAN
			path: ARRAYED_LIST [INTEGER]
		do
			print ("Depth-First Search (DFS)%N")
			print ("========================%N%N")

			-- Create adjacency list for graph:
			-- 0 -- 1 -- 2
			-- |    |
			-- 3 -- 4 -- 5
			--      |
			--      6

			graph := create_sample_graph

			print ("Graph adjacency list:%N")
			print_graph (graph)

			-- DFS from vertex 0
			create visited.make_filled (False, 0, 6)
			create path.make (7)

			print ("%NDFS traversal starting from vertex 0:%N")
			print ("Order: ")
			dfs (graph, 0, visited, path)
			print ("%N")

			-- Show path
			print ("Path: ")
			print_path (path)

			-- DFS to find path between vertices
			print ("%NFind path from 0 to 6:%N")
			path := find_path (graph, 0, 6)
			if path.is_empty then
				print ("No path found%N")
			else
				print ("Path: ")
				print_path (path)
			end
		end

feature -- DFS Algorithm

	dfs (graph: ARRAY [ARRAYED_LIST [INTEGER]]; vertex: INTEGER; visited: ARRAY [BOOLEAN]; path: ARRAYED_LIST [INTEGER])
			-- Perform DFS from vertex, recording visited vertices in path.
		require
			valid_vertex: graph.valid_index (vertex)
			valid_visited: visited.valid_index (vertex)
		local
			neighbors: ARRAYED_LIST [INTEGER]
			neighbor: INTEGER
			i: INTEGER
		do
			visited [vertex] := True
			path.extend (vertex)
			print (vertex.out + " ")

			neighbors := graph [vertex]
			from i := 1 until i > neighbors.count loop
				neighbor := neighbors.i_th (i)
				if not visited [neighbor] then
					dfs (graph, neighbor, visited, path)
				end
				i := i + 1
			end
		end

	dfs_iterative (graph: ARRAY [ARRAYED_LIST [INTEGER]]; start: INTEGER): ARRAYED_LIST [INTEGER]
			-- Iterative DFS using explicit stack.
		local
			stack: ARRAYED_LIST [INTEGER]
			visited: ARRAY [BOOLEAN]
			found: BOOLEAN
			vertex, neighbor: INTEGER
			neighbors: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create Result.make (graph.count)
			create stack.make (graph.count)
			create visited.make_filled (False, graph.lower, graph.upper)

			stack.extend (start)

			from until stack.is_empty loop
				vertex := stack.last
				stack.finish
				stack.remove

				if not visited [vertex] then
					visited [vertex] := True
					Result.extend (vertex)

					-- Add neighbors in reverse order for correct traversal
					neighbors := graph [vertex]
					from i := neighbors.count until i < 1 loop
						neighbor := neighbors.i_th (i)
						if not visited [neighbor] then
							stack.extend (neighbor)
						end
						i := i - 1
					end
				end
			end
		end

	find_path (graph: ARRAY [ARRAYED_LIST [INTEGER]]; start, goal: INTEGER): ARRAYED_LIST [INTEGER]
			-- Find path from start to goal using DFS.
		local
			visited: ARRAY [BOOLEAN]
			found: BOOLEAN
		do
			create Result.make (graph.count)
			create visited.make_filled (False, graph.lower, graph.upper)
			found := dfs_find_path (graph, start, goal, visited, Result)
		end

feature {NONE} -- Implementation

	dfs_find_path (graph: ARRAY [ARRAYED_LIST [INTEGER]]; curr, goal: INTEGER;
			visited: ARRAY [BOOLEAN]; path: ARRAYED_LIST [INTEGER]): BOOLEAN
			-- DFS helper to find path, returns True if goal found.
		local
			neighbors: ARRAYED_LIST [INTEGER]
			neighbor: INTEGER
			i: INTEGER
		do
			visited [curr] := True
			path.extend (curr)

			if curr = goal then
				Result := True
			else
				neighbors := graph [curr]
				from i := 1 until i > neighbors.count or Result loop
					neighbor := neighbors.i_th (i)
					if not visited [neighbor] then
						Result := dfs_find_path (graph, neighbor, goal, visited, path)
					end
					i := i + 1
				end

				if not Result then
					-- Backtrack
					path.finish
					path.remove
				end
			end
		end

	create_sample_graph: ARRAY [ARRAYED_LIST [INTEGER]]
			-- Create sample graph as adjacency list.
		local
			i: INTEGER
		do
			create Result.make_filled (create {ARRAYED_LIST [INTEGER]}.make (0), 0, 6)
			from i := 0 until i > 6 loop
				Result [i] := create {ARRAYED_LIST [INTEGER]}.make (3)
				i := i + 1
			end

			-- Add edges (undirected)
			add_edge (Result, 0, 1)
			add_edge (Result, 0, 3)
			add_edge (Result, 1, 2)
			add_edge (Result, 1, 4)
			add_edge (Result, 3, 4)
			add_edge (Result, 4, 5)
			add_edge (Result, 4, 6)
		end

	add_edge (graph: ARRAY [ARRAYED_LIST [INTEGER]]; u, v: INTEGER)
		do
			graph [u].extend (v)
			graph [v].extend (u)
		end

	print_graph (graph: ARRAY [ARRAYED_LIST [INTEGER]])
		local
			i, j: INTEGER
		do
			from i := graph.lower until i > graph.upper loop
				print ("  " + i.out + " -> ")
				from j := 1 until j > graph [i].count loop
					print (graph [i].i_th (j).out)
					if j < graph [i].count then print (", ") end
					j := j + 1
				end
				print ("%N")
				i := i + 1
			end
		end

	print_path (path: ARRAYED_LIST [INTEGER])
		local
			i: INTEGER
		do
			from i := 1 until i > path.count loop
				print (path.i_th (i).out)
				if i < path.count then print (" -> ") end
				i := i + 1
			end
			print ("%N")
		end

end
