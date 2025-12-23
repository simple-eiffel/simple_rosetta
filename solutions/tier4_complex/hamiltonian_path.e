note
	description: "[
		Rosetta Code: Hamiltonian path
		https://rosettacode.org/wiki/Hamiltonian_path

		Find a path that visits every vertex exactly once.
		NP-complete problem, uses backtracking.
	]"

class
	HAMILTONIAN_PATH

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create adjacency.make_filled (False, 0, vertex_count * vertex_count - 1)
		end

feature -- Graph Construction

	add_edge (v1, v2: INTEGER)
			-- Add undirected edge
		require
			valid_v1: v1 >= 0 and v1 < num_vertices
			valid_v2: v2 >= 0 and v2 < num_vertices
		do
			adjacency [v1 * num_vertices + v2] := True
			adjacency [v2 * num_vertices + v1] := True
		end

	has_edge (v1, v2: INTEGER): BOOLEAN
			-- Is there an edge between v1 and v2?
		require
			valid_v1: v1 >= 0 and v1 < num_vertices
			valid_v2: v2 >= 0 and v2 < num_vertices
		do
			Result := adjacency [v1 * num_vertices + v2]
		end

feature -- Algorithm

	find_hamiltonian_path: ARRAY [INTEGER]
			-- Find a Hamiltonian path if one exists
		local
			path: ARRAY [INTEGER]
			visited: ARRAY [BOOLEAN]
			start: INTEGER
		do
			create path.make_filled (-1, 0, num_vertices - 1)
			create visited.make_filled (False, 0, num_vertices - 1)

			-- Try starting from each vertex
			from start := 0 until start >= num_vertices loop
				path [0] := start
				visited [start] := True

				if hamiltonian_util (path, visited, 1) then
					Result := path
					start := num_vertices  -- Exit
				else
					visited [start] := False
					start := start + 1
				end
			end

			if Result = Void then
				create Result.make_empty
			end
		end

	find_hamiltonian_circuit: ARRAY [INTEGER]
			-- Find a Hamiltonian circuit if one exists
		local
			path: ARRAY [INTEGER]
			visited: ARRAY [BOOLEAN]
		do
			create path.make_filled (-1, 0, num_vertices - 1)
			create visited.make_filled (False, 0, num_vertices - 1)

			path [0] := 0
			visited [0] := True

			if hamiltonian_circuit_util (path, visited, 1) then
				Result := path
			else
				create Result.make_empty
			end
		end

feature -- Query

	has_hamiltonian_path: BOOLEAN
			-- Does graph have a Hamiltonian path?
		do
			Result := not find_hamiltonian_path.is_empty
		end

	has_hamiltonian_circuit: BOOLEAN
			-- Does graph have a Hamiltonian circuit?
		do
			Result := not find_hamiltonian_circuit.is_empty
		end

feature -- Access

	num_vertices: INTEGER

feature {NONE} -- Implementation

	adjacency: ARRAY [BOOLEAN]
			-- Adjacency matrix (flattened)

	hamiltonian_util (path: ARRAY [INTEGER]; visited: ARRAY [BOOLEAN]; pos: INTEGER): BOOLEAN
			-- Backtracking utility for Hamiltonian path
		local
			v: INTEGER
		do
			if pos = num_vertices then
				Result := True
			else
				from v := 0 until v >= num_vertices or Result loop
					if is_safe (v, path, visited, pos) then
						path [pos] := v
						visited [v] := True

						if hamiltonian_util (path, visited, pos + 1) then
							Result := True
						else
							path [pos] := -1
							visited [v] := False
						end
					end
					v := v + 1
				end
			end
		end

	hamiltonian_circuit_util (path: ARRAY [INTEGER]; visited: ARRAY [BOOLEAN]; pos: INTEGER): BOOLEAN
			-- Backtracking utility for Hamiltonian circuit
		local
			v: INTEGER
		do
			if pos = num_vertices then
				-- Check if there's an edge back to start
				Result := has_edge (path [pos - 1], path [0])
			else
				from v := 1 until v >= num_vertices or Result loop
					if is_safe (v, path, visited, pos) then
						path [pos] := v
						visited [v] := True

						if hamiltonian_circuit_util (path, visited, pos + 1) then
							Result := True
						else
							path [pos] := -1
							visited [v] := False
						end
					end
					v := v + 1
				end
			end
		end

	is_safe (v: INTEGER; path: ARRAY [INTEGER]; visited: ARRAY [BOOLEAN]; pos: INTEGER): BOOLEAN
			-- Can vertex v be added to path at position pos?
		do
			Result := has_edge (path [pos - 1], v) and not visited [v]
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: HAMILTONIAN_PATH
			path: ARRAY [INTEGER]
		do
			print ("Hamiltonian Path Demo:%N%N")

			-- Complete graph K5 (has both path and circuit)
			create graph.make (5)
			graph.add_edge (0, 1)
			graph.add_edge (0, 2)
			graph.add_edge (0, 3)
			graph.add_edge (0, 4)
			graph.add_edge (1, 2)
			graph.add_edge (1, 3)
			graph.add_edge (1, 4)
			graph.add_edge (2, 3)
			graph.add_edge (2, 4)
			graph.add_edge (3, 4)

			print ("Complete Graph K5:%N")
			path := graph.find_hamiltonian_path
			if not path.is_empty then
				print ("  Hamiltonian path: ")
				across path as v loop
					print (v.out)
					if not (@ v.target_index = path.upper) then
						print (" -> ")
					end
				end
				print ("%N")
			end

			path := graph.find_hamiltonian_circuit
			if not path.is_empty then
				print ("  Hamiltonian circuit: ")
				across path as v loop
					print (v.out + " -> ")
				end
				print (path [0].out + "%N")
			end

			-- Petersen graph (has Hamiltonian path but no circuit)
			print ("%NPetersen Graph:%N")
			create graph.make (10)
			-- Outer pentagon
			graph.add_edge (0, 1)
			graph.add_edge (1, 2)
			graph.add_edge (2, 3)
			graph.add_edge (3, 4)
			graph.add_edge (4, 0)
			-- Inner pentagram
			graph.add_edge (5, 7)
			graph.add_edge (7, 9)
			graph.add_edge (9, 6)
			graph.add_edge (6, 8)
			graph.add_edge (8, 5)
			-- Spokes
			graph.add_edge (0, 5)
			graph.add_edge (1, 6)
			graph.add_edge (2, 7)
			graph.add_edge (3, 8)
			graph.add_edge (4, 9)

			print ("  Has Hamiltonian path: " + graph.has_hamiltonian_path.out + "%N")
			print ("  Has Hamiltonian circuit: " + graph.has_hamiltonian_circuit.out + "%N")
		end

end
