
function value_iter(prop,reward,gamma,theta)

    a = size(prop,1)
    old = zeros(a,1,1)
    new = zeros(a)
    limit = 2*theta

    while limit > theta
        oyy = reward .+ gamma * permutedims(old,[2,1,3])
        #oyy = reward #.+ gamma * old
        apu = prop.*(oyy)
        #print("apu: \n", apu, "\n")
        summia = sum(apu, dims=2)
        #print(size(summia),"\n")
        #print("summia: ", summia, "\n")
        #new = reshape(maximum(summia,dims=3),s,1)
        new = maximum(summia,dims=3)
        #print("new: ", new, "\n")
        limit = maximum(abs.(old .- new), dims=1)
        limit = limit[1]
        #print("old: ", old, "\n")
        old = new
        print("Tolr: ", limit, "\n")
        #print("old: ", old, "\n")
        print("-----\n")
    end
    return old
end

function policya(prop,reward,gamma,old)
    summia = sum(prop.*(reward .+ gamma * permutedims(old,[2,1,3])), dims = 2)
    #apustus = reshape(summia,3,2)
    #print("\n summia polixcy \n", summia, "\n")
    #print("\n summia polixcy \n", size(summia), "\n")
    #print("\n apustus \n", apustus, "\n")
    #print("\n summia polixcy \n", size(apustus), "\n")
    apu_2 = Array{Any,1}(undef,size(summia,1))
    for i = 1:size(summia,1)
        helpp = summia[i,:,:]
        apu, apu_2[i] = findmax(helpp,dims=2)
        #print(summia[i,:,:], "\n")
        #print(apu_2, "\n")
    end
    #apu, apu_2 = findmax(summia,dims=3)
    return apu_2, summia
end

#i,j,k   state i -> j, action k

prop = zeros(6,6,3)
p_0_0 = 0.5
p_1_0 = 0.5

p_0_1 = 0.5
p_1_1 = 0.25
p_2_1 = 0.25

p_0_2 = 0.5
p_1_2 = 0.5

p_0_3 = 0.5
p_1_3 = 0.25
p_2_3 = 0.25

p_0_4 = 0.5
p_1_4 = 0.5

#state i -> j, action k
#S_0
prop[1,1,1]=1

prop[1,1,2]=p_0_0
prop[1,2,2]=p_1_0

#S_1
prop[2,2,1]=1

prop[2,2,2]=p_0_1
prop[2,5,2]=p_1_1
prop[2,3,2]=p_2_1

prop[2,2,3]=p_0_2
prop[2,3,3]=p_1_2

#S_2
prop[3,3,1]=1

prop[3,3,2]=p_0_3
prop[3,6,2]=p_1_3
prop[3,4,2]=p_2_3

prop[3,3,3]=p_0_4
prop[3,4,3]=p_1_4

# state i -> j, action k
reward = zeros(6,6,3)
reward[:,1,:] .= 1
reward[:,2,:] .= 1
reward[:,3,:] .= 1
reward[:,4,:] .= 100



tulos = value_iter(prop,reward,0.3,0.0001)
print("Values: ", tulos, "\n")

policy, summia = policya(prop,reward,0.3,tulos)

print("Best policy: ", "\n")
for i = 1:size(policy,1)
    print(policy[i][1][2], "\n")
end
