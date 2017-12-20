reset; 



#model classic.mod;
#model sequential.mod; 
model flow.mod; 
#data TSP_instances/xqf131.dat;
#data TSP_instances/dantzig42.dat;
data TSP_instances/eil51.dat;


# TSP heuristic

param curr_node default 1;
param next_city default 1;
param min_cost default 1000000;
param heuristic = 1;

if heuristic then {
    for {i in 1..n-1} {
        let min_cost := 10000000;
        for {j in CITIES : ord(j) != curr_node and sum {k in CITIES : ord(k) != ord(j) } x[j, k] == 0 } {
            if COST[curr_node, j] < min_cost then {
                let min_cost := COST[curr_node, j];
                let next_city := j;
            } 
        }
        let x[curr_node, next_city] := 1;
        let x[next_city,curr_node] := 1;
        let curr_node := next_city;
    }
    let x[curr_node, 1] := 1;
    let x[1, curr_node] := 1;
} 

 
option solver gurobi;
#option gurobi_options 'presolve 0'; option gurobi_options 'heurfrac 0'; option gurobi_options 'cuts 0'; 

# option classic model
#option gurobi_options 'timelim 60 cuts -1 mipstart 1';

# option sequential model
#option gurobi_options 'timelim 60 cuts -1 mipstart 1';

# option flow model
option gurobi_options 'timelim 360 flowpath 2 mipstart 1';
# option gurobi_options 'timelim 109 presolve 0 heurfrac 0 cuts 0 mipstart 1';


solve;
display _total_solve_elapsed_time;
