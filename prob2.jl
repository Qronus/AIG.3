# using Pkg; Pkg.add("https://github.com/QuantEcon/Games.jl")

#module beautifulmind 

using Games

#-----------------------------------------------------------------

# defines the simultaneous game
function init()

if uppercase("n") == uppercase(query("\n*****Simultaneous games ****\n\nDefine own game?(y/n)\n\n\tchoice: "))
    mat = Array{Float64}(undef, 2, 2, 2)
    mat[1, 1, :] = [3, 2]  
    mat[1, 2, :] = [2, 2]
    mat[2, 1, :] = [2, 3]
    mat[2, 2, :] = [5, 0]

    sim = NormalFormGame(mat)
    determineStrategy(sim)
    output(sim)
else



println("Defining own game\n")
    if 1 == parse(Int,query("choose input method\n\t1.by matrix\n\t2.by vector\n\n\tchoice: "))

        matrix = Array{Int}(undef, 2, 2, 2)
        for o in 1:2
            for i in 1:2
             
             str = query("Input values for row $o column $i e.g(2 5): ")
            matrix[o, i, :] =  [parse(Int,split(str," ")[1]), parse(Int,split(str," ")[2])]
    
            end
        end
        game = NormalFormGame(matrix)
        determineStrategy(game)
        output(game)
    else

         p1 = [1 2 ; 3 4]
          str = replace(query("Input player1 strategies e.g(2 5;3 7): "),";" => "")
          str = replace(str," " => "")

          for (i,x) in enumerate(str)
             p1[i]=parse(Int,x)
          end 

        p1 = Player(p1)

         
          p2 = [1 2 ; 3 4]
          str = replace(query("Input player2 strategies e.g(2 5;3 7): "),";" => "")
          str = replace(str," " => "")

          for (i,x) in enumerate(str)
             p2[i]=parse(Int,x)
         end 

        p2 = Player(p2)

        game = NormalFormGame(p1,p2)
        determineStrategy(game)
        output(game)
    end

  end
end

#-----------------------------------------------------------------

function determineStrategy(game)


    a = query("\n\nwhat is player1's first strategy e.g(a): ")
    b = query("\nwhat is player1's second strategy e.g(b): ")

    c = query("\nwhat is player2's first strategy e.g(c): ")
    d = query("\nwhat is player2's second strategy e.g(d): ")


    act11 = game.players[1].payoff_array[1] + game.players[1].payoff_array[3]

    act12 = game.players[1].payoff_array[2] +game.players[1].payoff_array[4]  

    act21 = game.players[2].payoff_array[1] + game.players[2].payoff_array[2]
    act22 = game.players[2].payoff_array[3] + game.players[2].payoff_array[4]

println("\n")

    if act11 > act12
        println("player1  dominant strategy: $a\n         dominated stratergy: $b")
    end

    if act12 > act11
        println("player1  dominant strategy: $b\n         dominated stratergy: $a")
    elseif act11 == act12
        println("player1's strategies are equal")
    end


     if(act21>act22)
        println("player2  dominant strategy: $c\n         dominated stratergy: $d")
    elseif(act22>act21)
        println("player2  dominant strategy: $d\n         dominated stratergy: $c")
    else
        println("player2's strategies are equal")
    end

   # best_responses(game.players[1], game.players[1])
   


   
    return
end

#-----------------------------------------------------------------

function output(game::NormalFormGame)
    equilibria = pure_nash(game)
    equilibriaNo = length(equilibria)

    if equilibriaNo == 0
        str = "no pure Nash equilibrium found"
    elseif equilibriaNo == 1
        str = "There is 1 equilibrium at:\n$(equilibria[1])"
    else
        str = "There is $equilibriaNo  equilibria:\n"
        for (i, E) in enumerate(equilibria)
            i < equilibriaNo ? str *= "$E, " : str *= "$E"
        end
    end
    println(join(["\n",str]))
    
end

#-----------------------------------------------------------------

function query(str::String)

    print(str);
   return input = readline();

end

#-----------------------------------------------------------------

init() #driver statement
#end #module
