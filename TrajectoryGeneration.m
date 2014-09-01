function [p,p_dot,p_ddot] = TrajectoryGeneration( p0, pf, p_dot0, p_dotf,...
    p_ddot0, p_ddotf, tf, poly )
%TRAJECTORYGENERATION Computes a trajectory from p0 to pf using the method
%specified in poly.
%   Detailed explanation goes here

clc;
close all;

% Ensure velocity constraint holds
assert(all(p_dot0 == 0) && all(p_dotf == 0),...
    'Velocities must be zero at end points');

t = 0:0.01:tf;
p = zeros(size(p0,1),size(t,2));
p_dot = p;
p_ddot = p;

%% Compute trajectory for end effector position
% Assuming initial and final joint velocity (p_dot0, p_dotf) equal to 0,
% generate a cubic polynomial that achieves the desired end position (pf)
% from the initial position (p0)
a0 = p0;
a1 = zeros(size(a0));
a2 = 3*(pf-p0)/tf^2;
a3 = -2*(pf-p0)/tf^3;

% Now compute trajectory for each dimension
for i = 1:length(p0)
p(i,:) = a0(i) + a1(i).*t + a2(i).*t.^2 + a3(i).*t.^3;
p_dot(i,:) = a1(i) + 2.*a2(i)*t + 3*a3(i).*t.^2;
p_ddot(i,:) = 2*a2(i) + 6*a3(i).*t;
end

%% Compute trajectory for end effector orientation
% Gets the initial rotation matrix from the end effector to the inertial frame
T = inv(ForwardKinematics);
R0i = T(1:3,1:3);



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
hold on;
plot3(p0(1),p0(2),p0(3),'.r','MarkerSize',20);
text(p0(1),p0(2),p0(3),'Start');
plot3(pf(1),pf(2),pf(3),'.r','MarkerSize',20);
text(pf(1),pf(2),pf(3),'End');
plot3(p(1,:),p(2,:),p(3,:));
title('3D Trajectory');
view(30,30);
grid on;


end

