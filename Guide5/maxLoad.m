function maximum= maxLoad(paths,shortestPaths,flowDemand,R)
%
% maximum= maxLoad(paths,shortestPaths,flowDemand,R)
% INPUTS:
% paths -         vector (size of no. of flows) with the path number
%                 selected for each flow
% shortestpaths - cell array with the k-shortest paths of each flow
% flowDemand -    vector (size of no. of flows) with the average flow
%                 bandwidth of each flow (in Mbps)
% R -             square matrix with capacity of each link (in Gbps)
%
% OUTPUT:
% maximum - the worst link load
nNodes=size(R,1);
nFlows= length(flowDemand);
aux= zeros(nNodes);
for f= 1:nFlows
    for k= 1:length(shortestPaths{f}{paths(f)})-1
        i= shortestPaths{f}{paths(f)}(k);
        j= shortestPaths{f}{paths(f)}(k+1);
        aux(i,j)= aux(i,j)+flowDemand(f);
    end
end
aux= aux./(1000*R);
aux(isnan(aux))= 0;
maximum= max(max(aux));
end