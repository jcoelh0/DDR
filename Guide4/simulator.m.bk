par.r= 6000000; %bps
par.f= 150000; %Bytes
par.S= 1000; %seconds

%added 9/5/19
N = 2; %number of simulations
results= zeros(N,3);

for it= 1:N
out = simulator1(par);
results(it,1)= out.AvgPacketLoss;
results(it,2)= out.AvgPacketDelay;
results(it,3)= out.TransThroughput;
end
%fprintf("Transmitted Bytes()= %f\n",out.transmittedBytes);

alfa= 0.1; %90% confidence interval%

PLossmedia = mean(results(:,1));
PLossmediaterm = norminv(1-alfa/2)*sqrt(var(results(:,1))/N);
fprintf("Average Packet Loss (%%)= %f\n",PLossmedia);
fprintf('90conf= %.2e +- %.2e ',PLossmedia,PLossmediaterm)

Pdealymedia= mean(results(:,2));
Pdealymediaterm = norminv(1-alfa/2)*sqrt(var(results(:,2))/N);
fprintf("Average Packet Delay (ms)= %f\n",Pdealymedia);
fprintf('90conf= %.2e +- %.2e ',Pdealymedia,Pdealymediaterm)

Trasmittedmedia =  mean(results(:,3));
Trasmittedmediaterm = norminv(1-alfa/2)*sqrt(var(results(:,3))/N);
fprintf("Transmitted Throughput (Mbps)= %f\n",Trasmittedmedia);
fprintf('90conf= %.2e +- %.2e ',Trasmittedmedia,Trasmittedmediaterm)

function out= simulator1(par)
    %in the queue
    %row per packet
    %one coluumn is size, the other is the time it takes to get into the system
    arrival= 0;
    departure= 1;
    terminate= 2;
       
    state=0;
    queueOccupation=0;    
    queue=[];
    
    totalPackets=0;
    lostPackets=0;
    instant= 0;
    delays=0;
    transmittedPackets=0;
    transmittedBytes=0;
    
    size=0;
    
    B= 64*0.19 + 1518*0.48 + (1517+65)/2 * (1-0.19-0.48);

    averageTimePacket= (8*B)/par.r;  %bpp/bps=spp

    eventList= [arrival exprnd(averageTimePacket); terminate par.S];
    
    
    while(eventList(1,1)~=terminate)
        if(eventList(1,1)==arrival)
            clock= eventList(1,2);
            eventList(1,:)=[];
            
            packetSize = generatePacketSize();
            
            totalPackets=totalPackets+1;
            
            eventList= [eventList; arrival clock+exprnd(averageTimePacket)];
            
            if(state==0) %free
                state=1;
                size= packetSize;
                instant= clock;
                eventList= [eventList; departure clock+(size*8)/10e6];
               
            else
                if(packetSize <= par.f-queueOccupation) %queue has space for this packet
                    %add packet to queue (structure with (i) the arrival time and (ii) the size of each queued packet
                    queue=[queue; clock packetSize];
                    queueOccupation=queueOccupation+packetSize;
                else
                    lostPackets=lostPackets+1;                    
                end
            end
        elseif(eventList(1,1)==departure)
            clock= eventList(1,2);
            eventList(1,:)=[];
            delays=delays+(clock-instant);
            transmittedBytes=transmittedBytes+size;
            transmittedPackets=transmittedPackets+1;
            if queueOccupation>0
                instant= queue(1,1);
                size= queue(1,2);
                
                eventList= [eventList; departure clock+(size*8)/10e6];
                
                queueOccupation= queueOccupation-size;
                queue(1,:)=[]; %delete packet from queue
            else
                state=0;%free
            end
        end
        
        eventList= sortrows(eventList,2);
    end
    
    out.AvgPacketLoss=100*(lostPackets/totalPackets);
    out.AvgPacketDelay=1000*(delays/transmittedPackets);
    out.TransThroughput=(8*transmittedBytes*1e-6)/par.S;
end

function packetSize= generatePacketSize()
    r=rand();
    if(r < 0.19)
        packetSize=64;
    elseif(r < 0.19+0.48)
        packetSize=1518;
    else
        packetSize=randi([65 1517]);
    end
end
