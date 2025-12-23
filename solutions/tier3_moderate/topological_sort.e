note
	description: "[
		Rosetta Code: Topological sort
		https://rosettacode.org/wiki/Topological_sort

		Linear ordering of vertices in DAG such that for every
		directed edge u->v, u comes before v.
	]"

class
	TOPOLOGICAL_SORT

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create adjacency.make_filled (Void, 0, vertex_count - 1)
			across 0 |..| (vertex_count - 1) as i loop
				adjacency [i] := create {ARRAYED_LIST [INTEGER]}.make (5)
			end
		end

feature -- Graph Construction

	add_edge (from_v, to_v: INTEGER)
			-- Add directed edge from from_v to to_v
		require
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		do
			if attached adjacency [from_v] as adj then
				adj.extend (to_v)
			end
		end

feature -- Algorithm

	sort: ARRAY [INTEGER]
			-- Return topological ordering (empty if cycle exists)
		local
			in_degree: ARRAY [INTEGER]
			queue: ARRAYED_LIST [INTEGER]
			result_list: ARRAYED_LIST [INTEGER]
			i, v, neighbor: INTEGER
		do
			-- Calculate in-degrees
			create in_degree.make_filled (0, 0, num_vertices - 1)
			from i := 0 until i >= num_vertices loop
				if attached adjacency [i] as adj then
					across adj as n loop
						in_degree [n] := in_degree [n] + 1
					end
				end
				i := i + 1
			end

			-- Initialize queue with zero in-degree vertices
			create queue.make (num_vertices)
			from i := 0 until i >= num_vertices loop
				if in_degree [i] = 0 then
					queue.extend (i)
				end
				i := i + 1
			end

			-- Process vertices
			create result_list.make (num_vertices)
			from until queue.is_empty loop
				v := queue.first
				queue.start
				queue.remove
				result_list.extend (v)

				if attached adjacency [v] as adj then
					across adj as n loop
						neighbor := n
						in_degree [neighbor] := in_degree [neighbor] - 1
						if in_degree [neighbor] = 0 then
							queue.extend (neighbor)
						end
					end
				end
			end

			-- Check for cycle
			if result_list.count = num_vertices then
				Result := result_list.to_array
			else
				create Result.make_empty  -- Cycle detected
				has_cycle := True
			end
		end

	sort_dfs: ARRAY [INTEGER]
			-- Topological sort using DFS
		local
			visited: ARRAY [BOOLEAN]
			result_stack: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create visited.make_filled (False, 0, num_vertices - 1)
			create result_stack.make (num_vertices)
			has_cycle := False

			from i := 0 until i >= num_vertices or has_cycle loop
				if not visited [i] then
					dfs_visit (i, visited, result_stack, create {ARRAY [BOOLEAN]}.make_filled (False, 0, num_vertices - 1))
				end
				i := i + 1
			end

			if has_cycle then
				create Result.make_empty
			else
				-- Reverse the stack
				create Result.make_filled (0, 1, result_stack.count)
				from i := 1 until i > result_stack.count loop
					Result [i] := result_stack [result_stack.count - i + 1]
					i := i + 1
				end
			end
		end

feature -- Status

	has_cycle: BOOLEAN
			-- Was a cycle detected in last sort?

	num_vertices: INTEGER

feature {NONE} -- Implementation

	adjacency: ARRAY [detachable ARRAYED_LIST [INTEGER]]

	dfs_visit (v: INTEGER; visited: ARRAY [BOOLEAN]; result_stack: ARRAYED_LIST [INTEGER]; in_stack: ARRAY [BOOLEAN])
			-- DFS visit for topological sort
		do
			if in_stack [v] then
				has_cycle := True
			elseif not visited [v] then
				in_stack [v] := True
				visited [v] := True

				if attached adjacency [v] as adj then
					across adj as n loop
						if not has_cycle then
							dfs_visit (n, visited, result_stack, in_stack)
						end
					end
				end

				in_stack [v] := False
				result_stack.extend (v)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: TOPOLOGICAL_SORT
			order: ARRAY [INTEGER]
		do
			print ("Topological Sort Demo:%N%N")

			-- Rosetta Code example: dependencies
			create graph.make (8)
			-- des_system_lib -> std synopsys dware gtech
			graph.add_edge (0, 1)
			graph.add_edge (0, 2)
			graph.add_edge (0, 3)
			graph.add_edge (0, 4)
			-- dw01 -> std synopsys dware gtech
			graph.add_edge (5, 1)
			graph.add_edge (5, 2)
			graph.add_edge (5, 3)
			graph.add_edge (5, 4)
			-- dw02 -> std synopsys dware
			graph.add_edge (6, 1)
			graph.add_edge (6, 2)
			graph.add_edge (6, 3)
			-- dw03 -> std synopsys dware
			graph.add_edge (7, 1)
			graph.add_edge (7, 2)
			graph.add_edge (7, 3)

			print ("Vertices: 0=des_system, 1=std, 2=synopsys, 3=dware, 4=gtech, 5=dw01, 6=dw02, 7=dw03%N%N")

			order := graph.sort
			if order.is_empty then
				print ("Cycle detected!%N")
			else
				print ("Topological order (Kahn's): ")
				across order as v loop
					print (v.out + " ")
				end
				print ("%N")
			end

			order := graph.sort_dfs
			if not graph.has_cycle then
				print ("Topological order (DFS):    ")
				across order as v loop
					print (v.out + " ")
				end
				print ("%N")
			end
		end

end
