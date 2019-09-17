
nAPs=4
W=40

avav4=[
2.369e-01
4.215e-01
6.240e-01
7.919e-01
]

nAPs=1
W=40
avav1=[
6.963e-02
1.613e-01
3.264e-01
5.759e-01
]


figure(1)

data = [avav1 avav4];

x= categorical({'60','90','120','150'});

hb = bar(x,data);

l = cell(1,2);
l{1}='nAPs=1'; l{2}='nAPs=4';    
legend(hb,l, 'Location','NorthWest');


set(hb(1), 'FaceColor','r')
set(hb(2), 'FaceColor','b')
xlabel('Number of mobile nodes N');
ylabel('Average Availability (y/100)')
title('Average Availability with W=40')

