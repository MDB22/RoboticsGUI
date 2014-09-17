function [x,y,z,k,theta,RFI] = TrajectoryGeneration(q, pf, qf, tf)
%TRAJECTORYGENERATION Computes a trajectory straightline trajectory to
% the given pose from the current pose using a cubic polynomial.
%
% Given the current joint angles of the robot (q), first computes the 
% inital pose of the robot using the ForwardKinematics function, then 
% computes the cubic polynomial that takes the robot from initial pose 
% p0 and q0 to the desired final pose pf and qf.
%
% This function assumes the the initial and final velocity and acceleration
% are zero, so only uses the position to compute the polynomial.
%
% Once the polynomial has been calculated, it can then be interpolated
% using time commands from the Processing sketch to generate the points
% along the desired path.

%% Initial set up
% Validate data input
valid = iscolumn(q) && iscolumn(pf) && iscolumn(qf);
assert(valid,['Joint angles, desired position and desired orientation'...
    ' should be input as column vectors.']);

% Function from computing rotation matrix from Yaw, Pitch, Roll parameters
RPY = @(roll,pitch,yaw)(rotz(yaw)*roty(pitch)*rotx(roll));

% Compute current pose
[RI0, p0] = ForwardKinematics(q);

%% Compute trajectory for end effector position
% Assuming initial and final joint velocity (p_dot0, p_dotf) equal to 0,
% generate a cubic polynomial that achieves the desired end position (pf)
% from the initial position (p0)
a0 = p0;
a1 = zeros(size(a0));
a2 = 3*(pf-p0)/tf^2;
a3 = -2*(pf-p0)/tf^3;

x = @(t)(a0(1) + a1(1)*t + a2(1)*t.^2 + a3(1)*t.^3);
y = @(t)(a0(2) + a1(2)*t + a2(2)*t.^2 + a3(2)*t.^3);
z = @(t)(a0(3) + a1(3)*t + a2(3)*t.^2 + a3(3)*t.^3);

%% Compute trajectory for end effector orientation
% Gets the initial rotation matrix from the end effector to the inertial frame
RF0 = RPY(qf(1),qf(2),qf(3))
RFI = RF0*RI0';

% Calculate the total rotation, and the axis we're rotating around
theta0 = 0;
thetaf = 2*acos(.5*sqrt(1+RFI(1,1)+RFI(2,2)+RFI(3,3)))
k = [RFI(3,2) - RFI(2,3);...
    RFI(1,3) - RFI(3,1);...
    RFI(2,1) - RFI(1,2)];
k = k./(2*sin(thetaf));
k = k./norm(k);

% Assume we start at rotation theta0 around our axis, and we wish to move
% to thetaf in time tf
a0 = theta0;
a1 = 0;
a2 = 3*(thetaf - theta0)/tf^2;
a3 = -2*(thetaf - theta0)/tf^3;

theta = @(t)(a0 + a1*t + a2*t.^2 + a3*t.^3);

for i = theta0:.01:thetaf
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
xf1 = RI0;

xi2 = [pf; pf; pf];
xf2 = RI0 * Re;
for i = 1:3
    v = xf2(:,i);
    xf2(:,i) = v/norm(v);
end

end

