% Plot the simulation results:

%plot to test W
%4 AP's
%N=60
avav60= [
2.369e-01
9.176e-01
9.885e-01];

%N=120
avav120= [
6.240e-01
9.912e-01
9.988e-01];


figure(1)


data = [avav60 avav120];

x= categorical({'40','60','80'});

hb = bar(x,data);

l = cell(1,2);
l{1}='N=60'; l{2}='N=120';    
legend(hb,l, 'Location','NorthWest');


set(hb(1), 'FaceColor','r')
set(hb(2), 'FaceColor','b')
xlabel('Radio range (W)');
ylabel('Average Availability (y/100)')
title('Average Availability with nAPs=4')

