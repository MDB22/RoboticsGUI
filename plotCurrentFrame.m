function  plotCurrentFrame(p0,pi,pf,RI0,Rt0)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

f = 10;

% Start and End points
plot3(p0(1),p0(2),p0(3),'.r','MarkerSize',20);
hold on;
text(p0(1),p0(2),p0(3),'Start');
plot3(pf(1),pf(2),pf(3),'.r','MarkerSize',20);
text(pf(1),pf(2),pf(3),'End');

% Path from start to finish
l = line([p0(1);pf(1)],[p0(2);pf(2)],[p0(3);pf(3)]);
set(l,'Color','black');
% Change in x
x = line([p0(1);pf(1)],[p0(2);p0(2)],[p0(3);p0(3)]);
set(x,'LineStyle','--','Color','red');
% Change in y
y = line([pf(1);pf(1)],[p0(2);pf(2)],[p0(3);p0(3)]);
set(y,'LineStyle','--','Color','green');
% Change in z
z = line([pf(1);pf(1)],[pf(2);pf(2)],[p0(3);pf(3)]);
set(z,'LineStyle','--','Color','blue');

% Initial Frame
bigQuiver([p0(1);p0(1);p0(1)],[p0(2);p0(2);p0(2)],[p0(3);p0(3);p0(3)],f*RI0(1,1:3),f*RI0(2,1:3),f*RI0(3,1:3),2);
% Final Frame
bigQuiver([pi(1);pi(1);pi(1)],[pi(2);pi(2);pi(2)],[pi(3);pi(3);pi(3)],f*Rt0(1,1:3),f*Rt0(2,1:3),f*Rt0(3,1:3),2);

title('3D Trajectory');
grid on;
view(30,30);
axis([-25,25,-15,35,415,465]);
xlabel('X');
ylabel('Y');
zlabel('Z');
drawnow;
hold off;

end

