Matrices;
nNodes= size(C,1);
w=0.75;
worstlinkload=0;
finalSolution= [];
ratio = 1;

while(worstlinkload < w)
    worstlinkload= inf;
    for i= 1:nNodes-1
        for j= 1+i:nNodes 
            if C(i,j) > 0
                auxR= R(i,j);
                auxL= L(i,j);             
                R(i,j)= 0;
                R(j,i)= 0;
                L(j,i)= inf;
                L(i,j)= inf;
                consump= sum(sum(C))/2-C(i,j);
                auxLocalSearch= localSearch(R,L,T);
                if auxLocalSearch < worstlinkload
                    worstlinkload= auxLocalSearch;
                    bestI= i;
                    bestJ= j;
                    solution= [i j consump worstlinkload];
                end
                R(i,j)= auxR;
                L(i,j)= auxL;
                R(j,i)= auxR;
                L(j,i)= auxL;
            end
        end
    end
    finalSolution= [finalSolution; solution]
    R(bestI, bestJ)= 0;
    R(bestJ, bestI)= 0;
    C(bestI, bestJ)= 0;
    C(bestJ, bestI)= 0;
    L(bestJ, bestI)= inf;
    L(bestI, bestJ)= inf;
end
finalSolution
secondFinalSolution= [];
auxLocalSearch=0;
while(auxLocalSearch < w)
    ratio= 1.1;
    for i= 1:nNodes-1
        for j= 1+i:nNodes
            if C(i,j) > 0
                auxR= R(i,j);
                auxL= L(i,j);             
                R(i,j)= 0;
                R(j,i)= 0;
                L(j,i)= inf;
                L(i,j)= inf;
                consump= sum(sum(C))/2-C(i,j);
                auxLocalSearch= localSearch(R,L,T);
                auxRatio= auxLocalSearch/C(i,j);
                if auxRatio < ratio && auxLocalSearch <= w
                    bestI= i;
                    bestJ= j;
                    ratio= auxRatio;
                    solutionRatio= [i j consump auxLocalSearch]
                end
                R(i,j)= auxR;
                L(i,j)= auxL;
                R(j,i)= auxR;
                L(j,i)= auxL;
            end
        end
    end
    secondFinalSolution= [secondFinalSolution; solutionRatio]
    R(bestI, bestJ)= 0;
    R(bestJ, bestI)= 0;
    C(bestI, bestJ)= 0;
    C(bestJ, bestI)= 0;
    L(bestJ, bestI)= inf;
    L(bestI, bestJ)= inf;
end

finalSolution
secondFinalSolution


function worstlinkload= localSearch(R,L,T)
nNodes= size(L,1);
nPaths= 5;
f= 0;
tic
for i=1:nNodes
    for j= 1:nNodes
        if T(i,j)>0
            f= f+1;
            flowDemand(f) = T(i,j);
            [shortestPaths{f}, tc] = kShortestPath(L, i, j, nPaths);
            if isempty(tc)
                worstlinkload= inf;
                return
                fprintf('Error: no connectivity\n');
            end
        end
    end
end
nFlows= length(flowDemand);
%solution that considers the first candidate path for all flows:
solution= ones(1,nFlows);
worstlinkload= maxLoad(solution,shortestPaths,flowDemand,R);
%from 6 to 3

%1 1 1 1 1 1
%2 1 1 1 1 1
%1 1 1 1 1 1


improved= 1; %true
counter= 0;
current= solution;
while improved == 1
    s= worstlinkload;
    counter = counter + 1;
    [counter s];
    for i=1:nFlows
        for j= 1:length(shortestPaths{i})
            if solution(i)~=j
                neighbour= solution;
                neighbour(i)= j;
                nextWorstlinkload= maxLoad(neighbour,shortestPaths,flowDemand,R);
                if nextWorstlinkload < worstlinkload
                    current= neighbour;
                    worstlinkload = nextWorstlinkload;
                end
            end
        end
    end
    if worstlinkload < s
        solution= current;
    	s= worstlinkload;
    else
    	improved= 0;
    end
end
% toc
% solution
% worstlinkload
end