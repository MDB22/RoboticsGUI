function [x,y,z,x_dot,y_dot,z_dot,roll,pitch,yaw,roll_dot,pitch_dot,yaw_dot]...
    = TrajectoryGeneration(q, pf, qf, tf)
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
% Once the polynomials have been calculated, they are differentiated to give
% task space velocities, which can then be interpolated using time commands
% from the Processing sketch to generate the points along the desired path.

%% Initial set up
% Validate data input
valid = iscolumn(q) && iscolumn(pf) && iscolumn(qf);
assert(valid,['Joint angles, desired position and desired orientation '...
    'should be input as column vectors.']);

% Function from computing rotation matrix from Yaw, Pitch, Roll parameters
RPY = @(roll,pitch,yaw)(rotz(yaw)*roty(pitch)*rotx(roll));

% Compute current pose
[RI0, p0] = ForwardKinematics(q);
% Compute final pose
RF0 = RPY(qf(1),qf(2),qf(3));
% Compute rotation between frames
RFI = RF0 * RI0';

%% Compute trajectory for end effector position
% Assuming initial and final poisition velocity (p_dot0, p_dotf) equal to 0,
% generate a cubic polynomial that achieves the desired end position (pf)
% from the initial position (p0)
a0 = p0;
a1 = zeros(size(a0));
a2 = 3*(pf-p0)/tf^2;
a3 = -2*(pf-p0)/tf^3;

x = @(t)(a0(1) + a1(1)*t + a2(1)*t.^2 + a3(1)*t.^3);
y = @(t)(a0(2) + a1(2)*t + a2(2)*t.^2 + a3(2)*t.^3);
z = @(t)(a0(3) + a1(3)*t + a2(3)*t.^2 + a3(3)*t.^3);

x_dot = @(t)(a1(1) + 2*a2(1)*t + 3*a3(1)*t.^2);
y_dot = @(t)(a1(2) + 2*a2(2)*t + 3*a3(2)*t.^2);
z_dot = @(t)(a1(3) + 2*a2(3)*t + 3*a3(3)*t.^2);

%% Compute trajectory for end effector orientation
% Initial rotation from current pose is 0
% yaw0 = atan2(RI0(2,1),RI0(1,1));
% pitch0 = atan2(-RI0(3,1),sqrt(RI0(3,2)^2 + RI0(3,3)^2));
% roll0= atan2(RI0(3,2),RI0(3,3));
% q0 = rad2deg([roll0;pitch0;yaw0])
q0 = [0;0;0];

% Find final orientation of end effector given rotation matrix RFI
yawf = atan2(RFI(2,1),RFI(1,1));
pitchf = atan2(-RFI(3,1),sqrt(RFI(3,2)^2 + RFI(3,3)^2));
rollf = atan2(RFI(3,2),RFI(3,3));
qf = rad2deg([rollf;pitchf;yawf]);

% Assuming initial and final orientation velocity (p_dot0, p_dotf) equal to 0,
% generate a cubic polynomial that achieves the desired end orientation (qf)
% from the initial orientation (q0)
a0 = q0;
a1 = zeros(size(q0));
a2 = 3*(qf - q0)/tf^2;
a3 = -2*(qf - q0)/tf^3;

roll = @(t)(a0(1) + a1(1)*t + a2(1)*t.^2 + a3(1)*t.^3);
pitch = @(t)(a0(2) + a1(2)*t + a2(2)*t.^2 + a3(2)*t.^3);
yaw = @(t)(a0(3) + a1(3)*t + a2(3)*t.^2 + a3(3)*t.^3);

roll_dot = @(t)(a1(1) + 2*a2(1)*t + 3*a3(1)*t.^2);
pitch_dot = @(t)(a1(2) + 2*a2(2)*t + 3*a3(2)*t.^2);
yaw_dot = @(t)(a1(3) + 2*a2(3)*t + 3*a3(3)*t.^2);

end

