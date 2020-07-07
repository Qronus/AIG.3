 #initialize queens variables and domains

    columns = [1, 2, 3, 4, 5, 6, 7, 8]
   rows = Dict(col => columns for col in columns)
   println("defining columns and rows")
   


#-----------------------------------------------------------------

mutable struct QueensConstraint
    variables::Vector{Int} 
    
   function QueensConstraint(columns::Vector{Int})
   println("creating constraint")
        variables = columns
        return new(variables)
    end
end

#-----------------------------------------------------------------

#checks if the constraint is satisfied returns boolean
function satisfied(cons::QueensConstraint,assignment)
println("check if satisfied")
     for (q1c,q1r) in assignment # q1c = queen 1 column, q1r = queen 1 row
        for q2c in range(q1c + 1, stop=length(cons.variables)+1) # q2c = queen 2 column
            if q2c in keys(assignment)
                q2r = assignment[q2c] # q2r = queen 2 row

                if q1r == q2r # same row?
                  return false
                end

                if abs(q1r-q2r) == abs(q1c-q2c)  # same diagonal?
                 return false
                end
            end
        end
    end

   return true # no conflict
end




#-----------------------------------------------------------------

#csp struct for 
struct CSP

    #the problem's fields
    variables::Vector
    domains::Dict{Int, Vector}
    constraints::Dict{Int, Vector{}}

    #constructor
    function CSP(vars, doms, cons=Dict())
    println("creating csp")
        variables = vars
        domains = doms
        constraints = cons

        for var in vars
            constraints[var] = Vector()
            if (!haskey(domains, var))
                error("Every variable should have a domain assigned to it.")
            end
        end
        return new(variables, domains, constraints)
    end
end

#-----------------------------------------------------------------

function add_constraint(csp:: CSP, constraint::QueensConstraint)

    for var in constraint.variables
    println("adding cons")
        if (!(var in csp.variables))
            error("Variable in constraint not in CSP")
        else
            push!(csp.constraints[var], constraint)
        end
    end
end

#-----------------------------------------------------------------

function consistent(csp:: CSP, variable, assignment)::Bool
println("check consistency")
    for constraint in csp.constraints[variable]
        if (!satisfied(constraint, assignment))
            return false
        end
        return true
    end
end


#-----------------------------------------------------------------

function backtracking_search(csp:: CSP,  assignment=Dict(), path=Dict())::Union{Dict,Nothing}
println("back tracking")
     # assignment is complete if every variable is assigned (our base case)
     if length(assignment) == length(csp.variables)
        return assignment
     end


    unassigned = [v for v in csp.variables if!(v in keys(assignment))]
#=
    # get all variables without assignments
    unassigned::Vector{Int} = []
    for v in csp.variables
        if (!haskey(assignment, v))
            push!(unassigned, v)
        end
    end

=#
    # get the every possible domain value of the first unassigned variable
    first = unassigned[1]
    # println(first)
    # pretty_print(csp.domains)
    for value in csp.domains[first]
        local_assignment = deepcopy(assignment)
        local_assignment[first] = value

        
        # if we're still consistent, we recurse (continue)
        if consistent(csp, first, local_assignment)
            # forward checking, prune future assignments that will be inconsistent
            for un in unassigned
                ass = deepcopy(local_assignment)
                for (i, val) in enumerate(csp.domains[un])
                    ass[un] = val
                    if un != first
                        if(!consistent(csp, un, ass))
                            deleteat!(csp.domains[un], i)
                        end
                    end
                end
            end

            path[first] = csp.domains
            # println("reduced")
            #out(csp.domains)
            result = backtracking_search(csp, local_assignment)

            #backtrack if nothing is found
            if result !== nothing
                out(path)
                return result
            end
        end
    end
    return nothing
end

#-----------------------------------------------------------------

function out(d::Dict, pre=1)

    for (k,v) in d
        if typeof(v) <: Dict
            s = "$(repr(k)) => "
            println(join(fill(" ", pre)) * s)
            out(v, pre+1+length(s))
        else
            println(join(fill(" ", pre)) * "$(repr(k)) => $(repr(v))")
        end
    end
    nothing
end
#-----------------------------------------------------------------


csp = CSP(columns,rows)
add_constraint(csp, QueensConstraint(columns))
solution = backtracking_search(csp)

if solution != Nothing
    print("solution is: ", solution)
else
    println("No solution found!")
end
