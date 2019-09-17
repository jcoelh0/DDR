par.r= [1e6 3e6 6e6]; %bps --------- size of flows = i
par.J{1}= [1]; %routing path of flow 1
par.J{2}= [1 2]; %routing path of flow 2
par.J{3}= [2]; %routing path of flow 3
par.C= [5e6 10e6]; %bps  ----------- size of links = j
par.f= [150e3 150e3]; %Bytes
par.S= 1000; %seconds

out = simulator(par);

for a= 1:length(par.r)
	fprintf("Average Packet Loss (%%)= %f\n",out.AvgPacketLoss(a));
	fprintf("Average Packet Delay (ms)= %f\n",out.AvgPacketDelay(a));
end

% results
% e) pl = 0% e ad= 7ms
% f) flow1: 0,002% e 18ms
%    flow2: 0,002% e 4,5ms
%    flow3: 0% e 26ms
function out= simulator(par)
    nLinks= size(par.C);
    nFlows= size(par.r);
    
    arrival= 0;
    retransmit= 1;
    departure= 2;
    terminate= 3;
       
    state= zeros(j,1); % 0 is free
    queueOccupation= zeros(j,1);    
    queue= cell(j, 3); % (1) the packet arrival time instant, 
    %(2) the packet size and (3) the packet flow
    
    totalPackets= zeros(i,1);
    lostPackets= zeros(i,1);
    delays= zeros(i,1);
    transmittedPackets= zeros(i,1);
    
    instant= zeros(j,1);
    syze= zeros(j,1);
    
    B= 64*0.19 + 1518*0.48 + (1517+65)/2 * (1-0.19-0.48);

    averageTimePacket= (8*B)./par.r;  %bpp/bps=spp
    
    % the type of event; the time instant of the event;  
    % the flow ID value i of the event; the link ID value j of the event
    eventList= [];
    
    for i=1:nFlows
        eventList= [eventList; arrival exprnd(averageTimePacket(i)) i par.J{i}(1) ];
    end
    eventList= [eventList; terminate par.S 0 0];
    eventList= sortrows(eventList,2);
    
    while(eventList(1,1)~=terminate)
        if(eventList(1,1)==arrival)
            clock= eventList(1,2);
            i= eventList(1,3);
            j= eventList(1,4);
            eventList(1,:)=[];
            
            packetSize = generatePacketSize();
            
            totalPackets=totalPackets+1;
            
            eventList= [eventList; arrival clock+exprnd(averageTimePacket(i)) i par.J{i}(1) ];
            
            % eventList= sortrows(eventList,2);
            
            if(state(j)==0) %free
                state(j)=1;
                syze(j)= packetSize;
                instant(j)= clock;
                %if the current link j is not the last link of the routing path of flow i
                if(j~=par.J{i}(end))
                    ind= find(par.J{i}==j);
                    eventList= [eventList; retransmit clock+(syze(j)*8)/par.C(j) i par.J{i}(ind+1) ];
                else
                    eventList= [eventList; departure clock+(syze(j)*8)/par.C(j) i j];
                end
            else
                if(syze(j) <= par.f-queueOccupation(j)) %queue has space for this packet
                    %(1) the packet arrival time instant, (2) the packet size and (3) the packet flow
                    queue{j}= [queue{j}; clock syze(j) j];
                    queueOccupation(j)=queueOccupation(j)+syze(j);
                else
                    lostPackets(j)=lostPackets(j)+1;                    
                end
            end
            
        elseif(eventList(1,1)==departure)
            clock= eventList(1,2);
            i= eventList(1,3);
            j= eventList(1,4);
            eventList(1,:)=[];
            
            delays=delays+(clock-instant);
            transmittedBytes=transmittedBytes+syze;
            transmittedPackets=transmittedPackets+1;
            if queueOccupation>0
                instant= queue(1,1);
                syze= queue(1,2);
                
                eventList= [eventList; departure clock+(syze*8)/10e6];
                
                queueOccupation= queueOccupation-syze;
                queue(1,:)=[]; %delete packet from queue
            else
                state=0;%free
            end
        end
        
        eventList= sortrows(eventList,2);
    end

    out.AvgPacketLoss=100*(lostPackets/totalPackets);
    out.AvgPacketDelay=1000*(delays/transmittedPackets);
end