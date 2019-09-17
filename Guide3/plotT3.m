
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

avav3=[
1.858e-01
3.441e-01
5.309e-01
7.411e-01
]

avav2=[
1.518e-01
2.437e-01
4.742e-01
6.779e-01
]

figure(1)

data = [avav1 avav2 avav3 avav4];

x= categorical({'1','2','3','4'});

hb = bar(x,data);

l = cell(1,4);
l{1}='N=60'; l{2}='N=90';  l{3}='N=120'; l{4}='N=150'; 
legend(hb,l, 'Location','NorthWest');


set(hb(1), 'FaceColor','r')
set(hb(2), 'FaceColor','b')
set(hb(3), 'FaceColor','g')
xlabel('Number of APs');
ylabel('Average Availability (y/100)')
title('Average Availability with W=40')

