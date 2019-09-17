%% e)
% par.r= [4e6]; %bps
 %par.J{1}= [1 2]; %routing path of flow 2
 %par.C= [10e6 5e6]; %bps
 %par.f= [150e3 150e3]; %Bytes
% par.S= 1000; %seconds

%% f)

%par.r= [7.4e6 2.3e6 2.5e6]; %bps
%par.J{1}= [1]; %routing path of flow 1
%par.J{2}= [1 2]; %routing path of flow 2
%par.J{3}= [2]; %routing path of flow 3
%par.C= [10e6 5e6]; %bps
%par.f= [7500 150e3]; %Bytes
%par.S= 200; %seconds

%% i)
    
par.r= [2e6 6e6 10e6 16e6 50e6 10e6 2e6 50e6 20e6 2e6 10e6 20e6]; %bps --------- size of flows = i
par.J{1}= [5]; %routing path of flow 1   Internet -> Datacenter
par.J{2}= [5 2]; %routing path of flow 2 I -> A
par.J{3}= [5 4]; %routing path of flow 3   I -> B
par.J{4}= [6]; %routing path of flow 4   D ->I
par.J{5}= [2]; %routing path of flow 5 D-> A
par.J{6}= [4]; %routing path of flow 6   D->B
par.J{7}= [1 6]; %routing path of flow 7   A->I
par.J{8}= [1]; %routing path of flow 8 A->D
par.J{9}= [1 4]; %routing path of flow 9   A->B
par.J{10}= [3 6]; %routing path of flow 10   B->I
par.J{11}= [3]; %routing path of flow 11 B->D
par.J{12}= [3 2]; %routing path of flow 12   B->A
par.C= [1e8 1e8 1e8 1e8 2e7 2e7]; %bps
par.f= [15e4 15e4 15e4 15e4 15e4 15e4]; %Bytes
par.S= 200; %seconds
fid = fopen("results2.txt","a");
tic
parfor k = 1:10
        res(k) = simulator(par)
end
toc
avgDelays = [res.AvgPacketDelay];
avgPckLoss = [res.AvgPacketLoss];
nFlows = size(par.r,2);
for flow = 1:nFlows
    avgDelaysPerFlow(flow) = mean(avgDelays(flow:nFlows:end));
    avgPktLossPerFlow(flow) = mean(avgPckLoss(flow:nFlows:end));
    confidenceDelaysPerFlow(flow) = norminv(1-0.1/2)*sqrt(var(avgDelays(flow:nFlows:end))/10);
    confidencePktLossPerFlow(flow) = norminv(1-0.1/2)*sqrt(var(avgPckLoss(flow:nFlows:end))/10);
    fprintf(fid,"%7d+-%7d\t%7d+-%7d\n",avgDelaysPerFlow(flow),confidenceDelaysPerFlow(flow),avgPktLossPerFlow(flow),confidencePktLossPerFlow(flow));
end
    
    

function res = simulator(par)
    
    
    %% EVENTS
    
    % Arrival - the arrival of the packet (indicated by a 1)
    % RETRANSMIT - the arrival of a packet to all links of its routing path except the first indicated by 2)
    % Departure - the termination of a packet transmission (indicated by 3)
    % Terminate - the termination of the simulation (indicated by a 0)
    
    ARRIVAL =  1;
    RETRANSMIT = 2;
    DEPARTURE = 3;
    TERMINATE = 0;

    B = 64*0.19 + 1518*0.48 + (1517+65)/2*(1-0.19-0.48);
    TempoMedioCheagadas = B * 8 ./ par.r;

    EventList =[];
    for i = 1:length(par.r)
        EventList = [ EventList; exprnd(TempoMedioCheagadas(i)) ARRIVAL i par.J{i}(1)];
    end
    EventList = sortrows([EventList; par.S TERMINATE 0 0 ]);
    
    
    %% STATE VARIABLES
    
    % State - indicates if link is FREE or BUSY
    % QueueOcupation - total number of bytes of the QUEUED packets
    % Queue - structure with ARRIVAL_TIME and SIZE of each packet, [link1][link2][link3]
    
    State = zeros(1,length(par.C));
    
    Queue = cell(1,length(par.C));
    QueueOcupation = zeros(1,length(par.C));
    
    %% STATISCAL COUNTERS
    
    % TotalPackets - NUMBER of packets ARRIVED to the system
    % LostPackets - NUMBER of packets DISCARDED due to buffer overflow
    % TransmittedBytes - NUMBER of TRANSMITTED bytes
    %TransmittedPackets - Number of TRANSMITTED packets
    TotalPackets = zeros(1,length(par.r));
    LostPackets = zeros(1,length(par.r));
    TransmittedBytes = zeros(1,length(par.r));
    TransmittedPackets = zeros(1,length(par.r));
    
    
    %% AUXILIARY VARIABLES
    
    % Instant - arrival TIME_INSTANT of the packet that is being
    % transmitted
    % Syze - SIZE, in bytes, of the packet that is being transmitted
    % Clock?
    Instant = zeros(1,length(par.C));
    Syze = zeros(1,length(par.C));
    Clock = 0;
    Delays = zeros(1,length(par.r)); 

    %Return variables
    res.AvgPacketLoss = zeros(1,length(par.r)); % per flow packet loss
    res.AvgPacketDelay = zeros(1,length(par.r));

    %% Code
    while EventList(1,2) ~= TERMINATE
        switch EventList(1,2)
            case ARRIVAL
                TMP_Syze = packetsize();
                Clock = EventList(1,1);
                Flow = EventList(1,3);
                Link = EventList(1,4);
                Next_Packet = exprnd(TempoMedioCheagadas(Flow))+ Clock;
                TotalPackets(Flow) = TotalPackets(Flow) +1;
                EventList = EventList(2:size(EventList,1),:);
                EventList = [EventList; Next_Packet ARRIVAL Flow Link ];
                if State(Link) == 0
                    State(Link) = 1;
                    Instant(Link) = Clock;
                    Syze(Link) = TMP_Syze;
                    Dep_time = Instant(Link) + (TMP_Syze*8)/par.C(Link);  %%%%%%%%%%%%%%%%%%%%%%%%%%
                    CurrentPath = par.J{Flow};
                    if(CurrentPath(end) == Link)    
                        EventList = [EventList; Dep_time DEPARTURE Flow Link];
                    else
                        nextLink = CurrentPath(find(CurrentPath == Link)+1);
                        EventList = [ EventList; Dep_time RETRANSMIT Flow nextLink ];
                    end
                
                else
                    if (QueueOcupation(Link) + TMP_Syze <= par.f(Link))
                        Queue{Link} = [Queue{Link}; Clock TMP_Syze Flow];
                        QueueOcupation(Link) = QueueOcupation(Link) + TMP_Syze;
                    else
                        LostPackets(Flow) = LostPackets(Flow) + 1;
                    end
                end
            case DEPARTURE
                Clock = EventList(1,1);
                Flow = EventList(1,3);
                Link = EventList(1,4);    
                EventList = EventList(2:size(EventList,1),:);
                Delays(Flow) = Delays(Flow) + Clock-Instant(Link);
                TransmittedBytes(Flow) = TransmittedBytes(Flow) +Syze(Link);
                TransmittedPackets(Flow) = TransmittedPackets(Flow) + 1;
                if(QueueOcupation(Link) > 0 )
                    queuetmp = Queue{Link}(1,:);
                    Instant(Link) = queuetmp(1);
                    Syze(Link) = queuetmp(2);
                    Dep_time = Clock + (Syze(Link)*8)/par.C(Link);
                    flow1 = queuetmp(3);
                    CurrentPath = par.J{flow1};
                    if(CurrentPath(end) == Link)
                        EventList = [EventList; Dep_time DEPARTURE flow1 Link];
                    else
                        nextLink = CurrentPath(find(CurrentPath == Link)+1);
                        EventList = [ EventList; Dep_time RETRANSMIT flow1 nextLink ];
                    end
                   Queue{Link} = Queue{Link}(2:end,:) ;
                   QueueOcupation(Link) = QueueOcupation(Link) - Syze(Link);
                else
                    State(Link) = 0;
                end
            case RETRANSMIT
                Clock = EventList(1,1);
                Flow = EventList(1,3);
                Link = EventList(1,4);
                EventList = EventList(2:size(EventList,1),:);
                CurrentPath = par.J{Flow};
                
                prevLink = CurrentPath(find(CurrentPath == Link)-1);
                Delays(Flow) = Delays(Flow) + Clock-Instant(prevLink);
                prevLinkInstant = Instant(prevLink);
                prevSize = Syze(prevLink);
                if(QueueOcupation(prevLink) > 0 )
                    queuetmp = Queue{prevLink}(1,:);
                    Instant(prevLink) = queuetmp(1);
                    Syze(prevLink) = queuetmp(2);
                    Dep_time = Clock + (queuetmp(2)*8)/par.C(prevLink);
                    CurrentPath_Queue = par.J{queuetmp(3)};
                    if(CurrentPath_Queue(end) == prevLink)
                        EventList = [EventList; Dep_time DEPARTURE queuetmp(3) prevLink];
                    else
                        nextLink = CurrentPath_Queue(find(CurrentPath_Queue == prevLink)+1);
                        EventList = [ EventList; Dep_time RETRANSMIT queuetmp(3) nextLink ];
                    end
                   Queue{prevLink} = Queue{prevLink}(2:end,:) ;
                   QueueOcupation(prevLink) = QueueOcupation(prevLink) - queuetmp(2);
                else
                    State(prevLink) = 0;
                end
                
                if State(Link) == 0
                    State(Link) = 1;
                    Instant(Link) = prevLinkInstant;
                    Syze(Link) = prevSize;
                    Dep_time = Clock + (prevSize*8)/par.C(Link);  %%%%%%%%%%%%%%%%%%%%%%%%%%
                    CurrentPath = par.J{Flow};
                    if(CurrentPath(end) == Link)    
                        EventList = [EventList; Dep_time DEPARTURE Flow Link];
                    else
                        nextLink = CurrentPath(find(CurrentPath == Link)+1);
                        EventList = [ EventList; Dep_time RETRANSMIT Flow nextLink ];
                    end
                
                elseif (QueueOcupation(Link) + prevSize <= par.f(Link))
                    Queue{Link} = [Queue{Link};  Clock prevSize Flow];
                    QueueOcupation(Link) = QueueOcupation(Link) + prevSize;
                else
                    LostPackets(Flow) = LostPackets(Flow) + 1;
                end
               
                           
        end
        EventList = sortrows(EventList);

    end
   
    res.AvgPacketLoss = 100 * LostPackets ./TotalPackets;
    res.AvgPacketDelay = 1000 * Delays ./TransmittedPackets;
 
    
    
end


function PacketSize = packetsize()
    r = rand();
    if(r < 0.19)
        PacketSize = 64;
        return 
    end
    if(r > 0.52)
        PacketSize = 1518;
        return
    end
    PacketSize = randi([65 1517]);
end

