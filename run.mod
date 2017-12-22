reset; 

# Choice of the model
# Uncomment the model you want

#model classic.mod; param model := 1;
model sequential.mod; param model := 2; 
#model flow.mod; param model := 3; 


# Set of files for the test
# For each filename, there should be a file filename.dat in the directory
# TSP_instances/

set test_files_small := {"burma14", "ulysses16", "ulysses22", "wi29", "bayg29", "dj38", "dantzig42", "att48", "eil51", "berlin52"};
set test_files_all := {"burma14", "ulysses16", "ulysses22", "wi29", "bayg29", "dj38", "dantzig42", "att48", "eil51", "berlin52", "xqf131"};
set test_files_big := {"xqf131"};

set test_files = test_files_small;

# Initialization of the variables

# Variables for the start heuristic

param curr_node default 1;
param next_city default 1;
param min_cost default 1000000;

# Variables for the options

param no_options = 0;
param heuristic_start = 1;
param verbose = 1;

# Test loop
# Solve the instance of each test file

for {filename in test_files} {
    reset data;
    
    data ('TSP_instances/' & filename & '.dat');

    if heuristic_start == 1 then {
        # Start heuristic => give easily a feasible solution
        #
        # Method : nearest neighbour
        #
        # Start with the node 1
        # At each step, take the nearest unvisited neighbour of the current node and move to this node
        # At the end, the tour is given by the order of the visited nodes 



        for {i in 1..n-1} {
            let min_cost := 10000000;
            for {j in CITIES : ord(j) != curr_node and sum {k in CITIES : ord(k) != ord(j) } x[j, k] == 0 and (curr_node, j) in LINKS} {
                if COST[curr_node, j] < min_cost then {
                    let min_cost := COST[curr_node, j];
                    let next_city := j;
                } 
            }
            let x[curr_node, next_city] := 1;
            let curr_node := next_city;
        }
        let x[curr_node, 1] := 1;
    } 
    
    # Solver options
    option solver gurobi;
    option presolve_warnings -1;
    option solver_msg 0;

    if no_options == 1 then {
        option gurobi_options 'timelim 360 outlev 1 presolve 0 cuts 0 heurfrac 0 mipstart 0';
    }
    else  {

        option gurobi_options 'timelim 360 wantsol 1 ';
        if model == 1 then {
            # option classic model
            option gurobi_options $gurobi_options 'cuts -1 mipstart 1';
        }

        if model == 2 then {
            # option sequential model
            option gurobi_options $gurobi_options 'covercuts 2 gubcover 2 networkcuts 2';
        }
        if model == 3  then {
            # option flow model
            option gurobi_options $gurobi_options 'cuts 2 flowcover 2 flowpath 2 covercuts 2 networkcuts 2';
        }

        if heuristic_start == 0 then {
            option gurobi_options $gurobi_options 'mipstart 0';
        }

        if verbose == 1 then {
            option gurobi_options $gurobi_options 'outlev 1'; 
        }
    }  
    printf('\n');
    printf('Computing ' & filename & ' ...\n');
    if verbose == 1 then {
        solve;
    } 
    else {
        solve > .garbage_file;
    }

    printf('Optimal objective : ' & TravelCost & '\n');
    printf('Computation time : ' & _solve_elapsed_time & '\n');

    printf('\n');
}
