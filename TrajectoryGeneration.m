function [p,p_dot,p_ddot] = TrajectoryGeneration( p0, pf, p_dot0, p_dotf,...
    p_ddot0, p_ddotf, tf, qf, poly )
%TRAJECTORYGENERATION Computes a trajectory from p0 to pf using the method
%specified in poly.
%   Detailed explanation goes here

clc;
close all;

dt = 0.001;

% Ensure velocity constraint holds
assert(all(p_dot0 == 0) && all(p_dotf == 0),...
    'Velocities must be zero at end points');

t = 0:dt:tf;

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
T = ForwardKinematics;
R0i = T(1:3,1:3);

% k remains constant for the whole rotation
k = [1 1 1];
k = k/norm(k);

a0 = 0;
a1 = 0;
a2 = 3*(qf)/tf^2;
a3 = -2*(qf)/tf^3;

q = a0 + a1.*t + a2.*t.^2 + a3.*t.^3;

for i = q
    e1 = k(1)*sin(i/2);
    e2 = k(2)*sin(i/2);
    e3 = k(3)*sin(i/2);
    e4 = cos(i/2);
    
    Re = [(1 - 2*e2^2 - 2*e3^2) 2*(e1*e2 - e3*e4) 2*(e1*e3 + e2*e4);...
        2*(e1*e2 + e3*e4) (1 - 2*e1^2 - 2*e3^2) 2*(e2*e3 - e1*e4);...
        2*(e1*e3 - e2*e4) 2*(e2*e3 + e1*e4) (1 - 2*e1^2 - 2*e2^2)];
end

save('Re.mat','Re');

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
save('xf2.mat','xf2');


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
axis([-1 5 -1 5 -1 5]);

% X,Y,Z position with components U,V,W

% Inertial Frame
quiver3(xi0(:,1),xi0(:,2),xi0(:,3),xf0(:,1),xf0(:,2),xf0(:,3));
% Initial Frame
quiver3(xi1(:,1),xi1(:,2),xi1(:,3),xf1(:,1),xf1(:,2),xf1(:,3));
% Rotation axis
quiver3(0,0,0,k(1),k(2),k(3));
quiver3(pf(1),pf(2),pf(3),k(1),k(2),k(3));
% Final Frame
quiver3(xi2(:,1),xi2(:,2),xi2(:,3),xf2(:,1),xf2(:,2),xf2(:,3));


title('3D Trajectory');
view(30,30);
grid on;
end

