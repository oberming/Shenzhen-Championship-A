cc
t = 0.35;
 x = 50:100:1150;
 x = (x-600)/600;
 y = [0,2,7,15,14,17,8,11,3,4,0,1];
plot(x,y);
hold on
plot(-1:0.01:1, 17 * gaussmf(-1:0.01:1,[t,0]));
hold off

cc
for t = 1:30000
    a(t) = abs(mean(normrnd(0,0.35,t,1)));
end
plot(1:30000,a);