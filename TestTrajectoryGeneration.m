% Helper function to run tests on TrajectoryGeneration.m

clc;
close all;

q = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];
% q = [0;0;0;0;0;0];

[RI0, p0] = ForwardKinematics(q);
RPY = @(roll,pitch,yaw)(rotx(roll)*roty(pitch)*rotz(yaw));

pf = [X;Y;Z];
% deltap = [10;-10;10];
% pf = p0 + deltap;

qf = [Roll;Pitch;Yaw];
q0 = [0;0;0];
% dq = [90;45;45];
% qf = q0 + dq;

if (exist('Time','var') == 1 && Time ~= 0)
    tf = Time;
else
    tf = 10;
end

[x,y,z,x_dot,y_dot,z_dot,roll,pitch,yaw,roll_dot,pitch_dot,yaw_dot]...
    = TrajectoryGeneration(q,pf,qf,tf);

dt = .001;
t = 0:dt:tf;

% Exact position and orientation
pos = [x(t);y(t);z(t)];
angles = [roll(t)+q0(1);pitch(t)+q0(2);yaw(t)+q0(3)];

% Approximate position and orientation using Euler's Approximation
x = zeros(size(t)); x(1) = p0(1);
y = zeros(size(t)); y(1) = p0(2);
z = zeros(size(t)); z(1) = p0(3);
roll = zeros(size(t)); roll(1) = q0(1);
pitch = zeros(size(t)); pitch(1) = q0(2);
yaw = zeros(size(t)); yaw(1) = q0(3);
for i = 2:numel(t)
x(i) = x(i-1) + dt*x_dot(t(i-1));
y(i) = y(i-1) + dt*y_dot(t(i-1));
z(i) = z(i-1) + dt*z_dot(t(i-1));
roll(i) = roll(i-1) + dt*roll_dot(t(i-1));
pitch(i) = pitch(i-1) + dt*pitch_dot(t(i-1));
yaw(i) = yaw(i-1) + dt*yaw_dot(t(i-1));
end

%% Display computed trajectories
% Plot exact and approximate position functions
figure;
hold on;
plot(t,pos(1,:),'--',t,pos(2,:),'-.',t,pos(3,:),':');
plot(t,x,'-.',t,y,':',t,z,'--');
title('End Effector Position');
legend('$x_{exact}$','$y_{exact}$','$z_{exact}$',...
    '$x_{approx}$','$y_{approx}$','$z_{approx}$');
% Plot exact and approximate orientation functions
figure;
hold on;
plot(t,angles(1,:),'--',t,angles(2,:),'-.',t,angles(3,:),':');
plot(t,roll,'-.',t,pitch,':',t,yaw,'--');
title('End Effector Rotation');
legend('$roll_{exact}$','$pitch_{exact}$','$yaw_{exact}$',...
    '$roll_{approx}$','$pitch_{approx}$','$yaw_{approx}$');
% Plot errors 
figure;
hold on;
plot(t,pos(1,:)-x,t,pos(2,:)-y,t,pos(3,:)-z);
title('Position error');
figure;
hold on;
plot(t,angles(1,:)-roll,t,angles(2,:)-pitch,t,angles(3,:)-yaw);
title('Orientation error');
% Visualise trajectory
figure;
for i = 1:1000:numel(t)
    pi = pos(:,i);
    
    % To get transformation matrix from initial to final frame
    % Rt0 = RtI*RI0
    Rt0 = RPY(roll(i),pitch(i),yaw(i))*RI0;
    plotCurrentFrame(p0,pi,pf,RI0,Rt0);
end