
N = 20; %number of simulations
resultados= zeros(1,N); %vector with N simulation results

%Parameters initialization:
par.N= 150;       % Number of mobile nodes
par.W= 60;       % Radio range (in meters)
par.delta= 1;    % Time slot (in seconds)
%par.AP = [200 150];   % Coordinates of each AP
%par.AP = [100 150;300 150];   % Coordinates of each AP
%par.AP = [100 150;200 150;300 150];   % Coordinates of each AP
%par.AP = [200 150;100 60;300 60;100 220;300 220];   % 
par.AP = [360 200;360 100; 50 150;50 250;200 50;200 250;350 50; 350 250;350 150];
%par.AP = [50 50; 50 250; 350 250; 350 50; 200 150]; %nAPs=5
%par.AP = [0 25;0 65; 0 105;0 145;0 185;0 225;0 265;0 305;
%          50 0;50 50;50 150; 50 200;50 250;50 300;
%          100 25;100 65;100 105; 100 145;100 185;100 225;100 265; 100 305;
%          150 0;150 50;150 150; 150 200;150 250;150 300;
%          200 25;200 65;200 105; 200 145;200 185;200 225;200 265; 200 305;
%          250 0;250 50;250 150; 250 200;250 250;250 300;
%          300 25;300 65;300 105; 300 145;300 185;300 225;300 265; 300 305;
%          350 0;350 50;350 150; 350 200;350 250;350 300
%          400 25;400 65;400 105; 400 145;400 185;400 225;400 265; 400 305;
%];


par.nAP = size(par.AP,1);  %Number of APs

T= 300;     % No. of time slots of the simulation

 
        for it= 1:N
            fprintf('it=%d ',it)
            [resultados(it) resultados2(it)] = simulation(par, T);
        end

        fprintf('\nN= %d ',par.N)
        fprintf('W= %d ',par.W)

        alfa= 0.1; %90% confidence interval%
        media = mean(resultados);
        term = norminv(1-alfa/2)*sqrt(var(resultados)/N);
        fprintf('AvAv= %.3e ',media)
        fprintf('90conf= %.2e+-%.2e ',media,term)

        alfa= 0.1; %90% confidence interval%
        media2 = mean(resultados2);
        term2 = norminv(1-alfa/2)*sqrt(var(resultados2)/N);
        fprintf('MinAv= %.3e ',media2)
        fprintf('90conf= %.2e+-%.2e\n',media2,term2)
        par.N = par.N + 30;


function [AverageAvailability, MinimumAvailability]= simulation(par, T)

   %Parameters initialization:
   %par.N= 150;       % Number of mobile nodes
   %par.W= 40;       % Radio range (in meters)
   %par.delta= 1;    % Time slot (in seconds)
   %par.AP = [200 150];   % Coordinates of each AP
   %par.AP = [100 150;300 150];   % Coordinates of each AP
   %par.AP = [100 150;200 150;300 150];   % Coordinates of each AP
   %par.AP = [50 50; 50 150;50 250;200 50;200 150;200 250;350 50; 350 250];   % Coordinates of each AP
   %par.nAP = size(par.AP,1);  %Number of APs

   %T= 300;     % No. of time slots of the simulation

   plotar = 0; % if plotar = 0, there is no visualization
               % if plotar = 1, node movement is visualized
               % if plotar = 2, node movement and connectivity are visualized

   % Initialization of mobile node positions and auxiliary matrices:
   map= InitializeState(par);
   % Initialization of statistical counters
   counter= InitializeCounter(par);
   L= [];
   C= [];
   h= waitbar(0,'Running simulation...');
   % Simulation cycles:
   for iter= 1:T
       waitbar(iter/T,h);
       % Update of  mobile node positions and auxiliary matrices:
       map= UpdateState(par,map);
       % Compute L with the node pairs with direct wireless links:
       L= ConnectedList(par,map);
       % Compute C with the nodes with Internet access:
       C= ConnectedNodes(par,L);
       % Update of statistical counters:
       counter= UpdateCounter(counter,C);
       % Visualization of the simulation:
       if plotar>0        
           visualize(par,map,L,C==1,plotar)
       end
   end
   delete(h)
   % Compute the final result: 
   [AverageAvailability, MinimumAvailability]= results(T,counter);
   %[AverageAvailability, MinimumAvailability]
end


function map= InitializeState(par)
    N= par.N;
    X= 400;
    Y= 300;
    pos= [50*randi([0 floor(Y/50)],N/2,1) Y*rand(N/2,1)];
    pos= [pos; X*rand(N/2,1) 50*randi([0 floor(X/50)],N/2,1)];
    vel_abs= 2*rand(N,1);
    vel_cont= randi(100,N,1);
    vel_angle= pi*randi([0 1],N/2,1) - pi/2;
    vel_angle= [vel_angle; pi*randi([0 1],N/2,1)];
    vel= [vel_abs.*cos(vel_angle) vel_abs.*sin(vel_angle)];
    map.pos= pos;
    map.vel= vel;
    map.vel_cont= vel_cont;
end

function counter= InitializeCounter(par)
% counter - an array with par.N values (one for each mobile node) to count
%           the number of time slots each node has Internet access
% This function creates the array 'counter' and initializes it with zeros
% in all positions. 
    counter = zeros(1,par.N);
    
end

function map= UpdateState(par,map)
    X= 400;
    Y= 300;
    N= par.N;
    pos= map.pos;
    vel= map.vel;
    vel_cont= map.vel_cont;
    delta= par.delta;    
    max_pos= [X*ones(N,1) Y*ones(N,1)];
    continuar= [vel_cont>0 vel_cont>0];
    pos= pos + delta*continuar.*vel;
    vel(pos<=0)= -vel(pos<=0);
    pos(pos<0)= 0;
    vel(pos>=max_pos)= -vel(pos>=max_pos);
    pos(pos>max_pos)= max_pos(pos>max_pos);
    map.pos= pos;
    map.vel= vel;
    aux= zeros(N,1);
    for j=find(vel_cont==1)
        aux(j)= -randi(40);
    end
    for j=find(vel_cont==-1)
        aux(j)= randi(100);
    end
    aux(vel_cont>1)= vel_cont(vel_cont>1)-1;
    aux(vel_cont<-1)= vel_cont(vel_cont<-1)+1;
    map.vel_cont= aux;
end

function counter= UpdateCounter(counter,C)
% This function increments the values of array 'counter' for mobile nodes
% that have Internet access.
    counter=counter+C;
end

function L= ConnectedList(par,map)
% map.pos - a matrix with par.N rows and 2 columns; each row identifies the (x,y)
%           coordinates of each mobile node
% L -       a matrix with 2 columns; each row identifies a pair of nodes (mobile
%           nodes and AP nodes) with direct wireless links between them
% This function computes matrix 'L' based on matrix map.pos.
%

    L=[];
    mat=[map.pos; par.AP];
    
    for i=1:par.N
        for j=i+1:par.N+par.nAP
            if sqrt((mat(j,1)-mat(i,1))^2 + (mat(j,2)-mat(i,2))^2) < par.W
                L=[L; i j];
            end
        end
    end
end

function C= ConnectedNodes(par,L)
% C - an array with N values (one for each mobile node) that is 1 in 
%     position i if mobile node i has Internet access
% This function computes array 'C' based on matrix 'L' with the node pairs
% that have direct wireless links.
%
% NOTE: To develop this function, check MATLAB function 'distances' that
%       computes shortest path distances of a graph.
%
    C=[];
    L=[L; par.N+par.nAP par.N+par.nAP]; 
    
    %https://www.mathworks.com/help/matlab/ref/graph.distances.html
    %We create a graph using s as Right column of L and t as Left column of L.
    s = L(:, 2);
    t = L(:, 1);
    G = graph(s,t);
    d = distances(G, 1:par.N, par.N+1:par.N+par.nAP);
    %now we have to search for the shortest path between nodes and APs,
    %this will return a matrix.
    %we iterate over that matrix to find the distance and set C(i).
        
	for i=1:par.N
        for j=par.N+1:par.N+par.nAP
            val = min(d(i,:));
            if val < Inf
                C(i) = 1;
                break;
            else
                C(i) = 0;
            end
        end
    end
    
end

function [AverageAvailability, MinimumAvailability]= results(T,counter)
% This function computes the average and the minimum availability (values
% between 0 and 1) based on array 'counter' and on the total number of
% time slots T.
    AverageAvailability = mean(counter)/T;
    MinimumAvailability = min(counter)/T;

end

function visualize(par,map,L,C,plotar)
    N= par.N;
    X= 400;
    Y= 300;
    pos= map.pos;
    AP= par.AP;
    nAP= par.nAP;
    plot(AP(1:nAP,1),AP(1:nAP,2),'s','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',12)
    hold on
    plot(pos(1:N,1),pos(1:N,2),'o','MarkerEdgeColor','r','MarkerFaceColor','r')
    if plotar==2
        pos=[pos;AP];
        for i=1:size(L,1)
            plot([pos(L(i,1),1) pos(L(i,2),1)],[pos(L(i,1),2) pos(L(i,2),2)],'b')
        end
        plot(pos(C,1),pos(C,2),'o','MarkerEdgeColor','b','MarkerFaceColor','b')
    end
    axis([-20 X+20 -20 Y+20])
    grid on
    set(gca,'xtick',0:50:X)
    set(gca,'ytick',0:50:Y)
    drawnow
    hold off
end
