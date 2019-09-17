par.r= 6000000; %bps
par.f= 150000; %Bytes
par.S= 1000; %seconds


out = simulator1(par);

fprintf("Average Packet Loss (%%)= %f\n",out.AvgPacketLoss);
fprintf("Average Packet Delay (ms)= %f\n",out.AvgPacketDelay);
fprintf("Transmitted Throughput (Mbps)= %f\n",out.TransThroughput);



function out= simulator1(par)
    out.AvgPacketLoss=0;
    out.AvgPacketDelay=0;
    out.TransThroughput=0;
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
    delays=0;
    transmitedPackets=0;
    transmitedBytes=0;
    
    instant=0;
    size=0;
    
    B= 64*0.19 + 1518*0.48 + (1517+65)/2 * (1-0.19-0.48)

    averageTimePacket= (8*B)/par.r;  %bpp/bps=spp

    %interval time arrivals
    randomTimeNewArrival= exprnd(averageTimePacket);

    eventList= [arrival randomTimeNewArrival; terminate par.S];
    
    
    while(eventList(1,1)~=terminate)
        if(eventList(1,1)==arrival)
            eventList(1,:)=[];
            
            
        elseif(eventList(1,1)==departure)
             Departure;
        
        
        end
    end
    
end

