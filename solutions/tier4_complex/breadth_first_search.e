note
	description: "[
		Rosetta Code: Breadth-first search
		https://rosettacode.org/wiki/Breadth-first_search

		Implement BFS for graph traversal and shortest path in unweighted graphs.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Breadth-first_search"

class
	BREADTH_FIRST_SEARCH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate breadth-first search.
		local
			graph: ARRAY [ARRAYED_LIST [INTEGER]]
			path: ARRAYED_LIST [INTEGER]
		do
			print ("Breadth-First Search (BFS)%N")
			print ("==========================%N%N")

			-- Create adjacency list for graph:
			-- 0 -- 1 -- 2
			-- |    |
			-- 3 -- 4 -- 5
			--      |
			--      6

			graph := create_sample_graph

			print ("Graph adjacency list:%N")
			print_graph (graph)

			-- BFS from vertex 0
			print ("%NBFS traversal starting from vertex 0:%N")
			print ("Order: ")
			path := bfs (graph, 0)
			print_list (path)
			print ("%N")

			-- Find shortest path
			print ("%NShortest path from 0 to 6:%N")
			path := shortest_path (graph, 0, 6)
			if path.is_empty then
				print ("No path found%N")
			else
				print ("Path: ")
				print_path (path)
				print ("Distance: " + (path.count - 1).out + " edges%N")
			end

			-- Another shortest path
			print ("%NShortest path from 2 to 3:%N")
			path := shortest_path (graph, 2, 3)
			print ("Path: ")
			print_path (path)
			print ("Distance: " + (path.count - 1).out + " edges%N")
		end

feature -- BFS Algorithm

	bfs (graph: ARRAY [ARRAYED_LIST [INTEGER]]; start: INTEGER): ARRAYED_LIST [INTEGER]
			-- BFS traversal from start vertex, returns order of visited vertices.
		require
			valid_start: graph.valid_index (start)
		local
			queue: ARRAYED_LIST [INTEGER]
			visited: ARRAY [BOOLEAN]
			vertex, neighbor: INTEGER
			neighbors: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create Result.make (graph.count)
			create queue.make (graph.count)
			create visited.make_filled (False, graph.lower, graph.upper)

			queue.extend (start)
			visited [start] := True

			from until queue.is_empty loop
				vertex := queue.first
				queue.start
				queue.remove

				Result.extend (vertex)

				neighbors := graph [vertex]
				from i := 1 until i > neighbors.count loop
					neighbor := neighbors.i_th (i)
					if not visited [neighbor] then
						visited [neighbor] := True
						queue.extend (neighbor)
					end
					i := i + 1
				end
			end
		end

	shortest_path (graph: ARRAY [ARRAYED_LIST [INTEGER]]; start, goal: INTEGER): ARRAYED_LIST [INTEGER]
			-- Find shortest path from start to goal using BFS.
		require
			valid_start: graph.valid_index (start)
			valid_goal: graph.valid_index (goal)
		local
			queue: ARRAYED_LIST [INTEGER]
			visited: ARRAY [BOOLEAN]
			parent: ARRAY [INTEGER]
			vertex, neighbor: INTEGER
			neighbors: ARRAYED_LIST [INTEGER]
			i: INTEGER
			found: BOOLEAN
		do
			create Result.make (graph.count)
			create queue.make (graph.count)
			create visited.make_filled (False, graph.lower, graph.upper)
			create parent.make_filled (-1, graph.lower, graph.upper)

			if start = goal then
				Result.extend (start)
			else
				queue.extend (start)
				visited [start] := True

				from until queue.is_empty or found loop
					vertex := queue.first
					queue.start
					queue.remove

					neighbors := graph [vertex]
					from i := 1 until i > neighbors.count or found loop
						neighbor := neighbors.i_th (i)
						if not visited [neighbor] then
							visited [neighbor] := True
							parent [neighbor] := vertex
							queue.extend (neighbor)

							if neighbor = goal then
								found := True
							end
						end
						i := i + 1
					end
				end

				-- Reconstruct path
				if found then
					from vertex := goal until vertex = -1 loop
						Result.put_front (vertex)
						vertex := parent [vertex]
					end
				end
			end
		end

	connected_components (graph: ARRAY [ARRAYED_LIST [INTEGER]]): ARRAYED_LIST [ARRAYED_LIST [INTEGER]]
			-- Find all connected components in graph.
		local
			visited: ARRAY [BOOLEAN]
			i: INTEGER
			component: ARRAYED_LIST [INTEGER]
		do
			create Result.make (5)
			create visited.make_filled (False, graph.lower, graph.upper)

			from i := graph.lower until i > graph.upper loop
				if not visited [i] then
					component := bfs_mark_visited (graph, i, visited)
					Result.extend (component)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	bfs_mark_visited (graph: ARRAY [ARRAYED_LIST [INTEGER]]; start: INTEGER;
			visited: ARRAY [BOOLEAN]): ARRAYED_LIST [INTEGER]
			-- BFS that marks vertices as visited in provided array.
		local
			queue: ARRAYED_LIST [INTEGER]
			vertex, neighbor: INTEGER
			neighbors: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create Result.make (graph.count)
			create queue.make (graph.count)

			queue.extend (start)
			visited [start] := True

			from until queue.is_empty loop
				vertex := queue.first
				queue.start
				queue.remove
				Result.extend (vertex)

				neighbors := graph [vertex]
				from i := 1 until i > neighbors.count loop
					neighbor := neighbors.i_th (i)
					if not visited [neighbor] then
						visited [neighbor] := True
						queue.extend (neighbor)
					end
					i := i + 1
				end
			end
		end

	create_sample_graph: ARRAY [ARRAYED_LIST [INTEGER]]
		local
			i: INTEGER
		do
			create Result.make_filled (create {ARRAYED_LIST [INTEGER]}.make (0), 0, 6)
			from i := 0 until i > 6 loop
				Result [i] := create {ARRAYED_LIST [INTEGER]}.make (3)
				i := i + 1
			end

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

	print_list (list: ARRAYED_LIST [INTEGER])
		local
			i: INTEGER
		do
			from i := 1 until i > list.count loop
				print (list.i_th (i).out)
				if i < list.count then print (", ") end
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
