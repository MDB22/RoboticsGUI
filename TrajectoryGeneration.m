function [trajectory] = TrajectoryGeneration(q, pf, qf, tf)
%TRAJECTORYGENERATION Computes a trajectory straightline trajectory to
% the given pose from the current pose using a cubic polynomial.
%
% Given the joint angles of the robot (q), first computes the inital pose
% of the robot using the ForwardKinematics function, then computes the
% cubic polynomial that takes the robot from initial pose p0 and q0 to
% the desired final pose pf and qf.
%
% This function assumes the the inital and final velocity and aceleration
% are zero, so only uses the position to compute the polynomial.
%
% Once the polynomial has been calculated, it can then be interpolated
% using time commands from the Processing sketch to generate the points
% along the desired path.

clc;
close all;

T = ForwardKinematics(q);

RPY = @(roll,pitch,yaw)(rotz(yaw)*roty(pitch)*rotx(roll));

%% Compute trajectory for end effector position
% Assuming initial and final joint velocity (p_dot0, p_dotf) equal to 0,
% generate a cubic polynomial that achieves the desired end position (pf)
% from the initial position (p0)
p0 = T(1:3,4);

a0 = p0;
a1 = zeros(size(a0));
a2 = 3*(pf-p0)/tf^2;
a3 = -2*(pf-p0)/tf^3;

%% Compute trajectory for end effector orientation
% Gets the initial rotation matrix from the end effector to the inertial frame
R0I = T(1:3,1:3);
R0F = RPY(qf(1),qf(2),qf(3));

% k remains constant for the whole rotation, but we should normalize
k = [1 0 0];
k = k/norm(k);

% Read joint angles to get initial angle
a0 = q0;
a1 = 0;
a2 = 3*(qf - q0)/tf^2;
a3 = -2*(qf - q0)/tf^3;

for i = q
    e1 = k(1)*sind(i/2);
    e2 = k(2)*sind(i/2);
    e3 = k(3)*sind(i/2);
    e4 = cosd(i/2);
    
    Re = [(1 - 2*e2^2 - 2*e3^2) 2*(e1*e2 - e3*e4) 2*(e1*e3 + e2*e4);...
        2*(e1*e2 + e3*e4) (1 - 2*e1^2 - 2*e3^2) 2*(e2*e3 - e1*e4);...
        2*(e1*e3 - e2*e4) 2*(e2*e3 + e1*e4) (1 - 2*e1^2 - 2*e2^2)];
end

xi0 = zeros(3,3);
xf0 = [ 1 0 0; 0 1 0; 0 0 1];

xi1 = xi0;
xf1 = R0i;

xi2 = [pf; pf; pf];
xf2 = R0i * Re;
for i = 1:3
    v = xf2(:,i);
    xf2(:,i) = v/norm(v);
end


%% Display computed trajectories
figure;
plot(t,p);
title('End Effector Position');
legend('x','y','z');
figure;
plot(t,p_dot);
title('End Effector Velocity');
legend('x','y','z');
figure;
plot(t,p_ddot);
title('End Effector Acceleration');
legend('x','y','z');
figure;
plot(t,q);
title('End Effector Rotation');
legend('\theta');
figure;
hold on;
plot3(p0(1),p0(2),p0(3),'.r','MarkerSize',20);
text(p0(1),p0(2),p0(3),'Start');
plot3(pf(1),pf(2),pf(3),'.r','MarkerSize',20);
text(pf(1),pf(2),pf(3),'End');
plot3(p(1,:),p(2,:),p(3,:));
axis([-6 6 -6 6 -6 6]);
xlabel('X');
ylabel('Y');
zlabel('Z');

% X,Y,Z position with components U,V,W
% Inertial Frame
bigQuiver(xi0(:,1),xi0(:,2),xi0(:,3),xf0(:,1),xf0(:,2),xf0(:,3),4);
% Initial Frame
bigQuiver(xi1(:,1),xi1(:,2),xi1(:,3),xf1(:,1),xf1(:,2),xf1(:,3),2);
% Rotation axis
bigQuiver(0,0,0,k(1),k(2),k(3),2);
bigQuiver(pf(1),pf(2),pf(3),k(1),k(2),k(3),2);
% Final Frame
bigQuiver(xi2(:,1),xi2(:,2),xi2(:,3),xf2(:,1),xf2(:,2),xf2(:,3),2);

title('3D Trajectory');
view(30,30);
grid on;
end

