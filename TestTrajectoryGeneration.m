% Helper function to run TrajectoryGeneration.m from Processing without
% having to run all the extra commands

clc;
close all;

q = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];
q = [0;0;0;0;0;0];

T = ForwardKinematics(q);

p0 = T(1:3,end);
p0 = [100;100;100]
pf = [X;Y;Z];
pf = [p0(1)+100;p0(2);p0(3)]

qf = [Roll;Pitch;Yaw];
qf = [0;0;160];

if (Time ~= 0)
    tf = Time;
else
    tf = 10;
end

[x,y,z,k,theta,RFI] = TrajectoryGeneration(q,pf,qf,tf);

t = 0:.01:tf;
px = x(t);
py = y(t);
pz = z(t);
p = [px;py;pz];

%% Display computed trajectories
figure;
plot(t,p);
title('End Effector Position');
legend('x','y','z');
% figure;
% plot(t,p_dot);
% title('End Effector Velocity');
% legend('x','y','z');
% figure;
% plot(t,p_ddot);
% title('End Effector Acceleration');
% legend('x','y','z');
% figure;
% plot(t,q);
% title('End Effector Rotation');
% legend('\theta');
figure;
hold on;
plot3(p0(1),p0(2),p0(3),'.r','MarkerSize',20);
text(p0(1),p0(2),p0(3),'Start');
plot3(pf(1),pf(2),pf(3),'.r','MarkerSize',20);
text(pf(1),pf(2),pf(3),'End');
plot3(p(1,:),p(2,:),p(3,:));
axis([0 600 0 600 0 600]);
xlabel('X');
ylabel('Y');
zlabel('Z');

% X,Y,Z position with components U,V,W
% % Inertial Frame
% bigQuiver(xi0(:,1),xi0(:,2),xi0(:,3),xf0(:,1),xf0(:,2),xf0(:,3),4);
% Initial Frame
T
bigQuiver([p0(1);p0(1);p0(1)],[p0(2);p0(2);p0(2)],[p0(3);p0(3);p0(3)],10*T(1:3,1),10*T(1:3,2),10*T(1:3,3),2);
% Rotation axis
bigQuiver(p0(1),p0(2),p0(3),k(1),k(2),k(3),1);
bigQuiver(pf(1),pf(2),pf(3),k(1),k(2),k(3),1);
% Final Frame
bigQuiver([pf(1);pf(1);pf(1)],[pf(2);pf(2);pf(2)],[pf(3);pf(3);pf(3)],10*RFI(1:3,1),10*RFI(1:3,2),10*RFI(1:3,3),2);

title('3D Trajectory');
view(30,30);
grid on;