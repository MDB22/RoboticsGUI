% Helper function to run tests on TrajectoryGeneration.m

%clc;
%close all;

%q = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];
 q0 = [10;10;10;10;10;10];

[RI0, p0] = ForwardKinematics(q0);
RPY = @(roll,pitch,yaw)(rotx(roll)*roty(pitch)*rotz(yaw));

X = 20;
Y = 20;
Z = 400;

pf = [X;Y;Z];
% deltap = [10;-10;10];
% pf = p0 + deltap;

Roll = 0;
Pitch = 0;
Yaw = 0;

rf = [Roll;Pitch;Yaw];
r0 = [0;0;0];
% dq = [90;45;45];
% qf = q0 + dq;

if (exist('Time','var') == 1 && Time ~= 0)
    tf = Time;
else
    tf = 10;
end

tf = 0.005;

[xRef,yRef,zRef,xRef_dot,yRef_dot,zRef_dot,rollRef,pitchRef,...
    yawRef,rollRef_dot,pitchRef_dot,yawRef_dot]...
    = TrajectoryGeneration(q0,pf,rf,tf);


dt = .001;
t = 0:dt:tf;

% Exact desired position and orientation
posRef = [xRef(t);yRef(t);zRef(t)];
angles = [rollRef(t)+r0(1);pitchRef(t)+r0(2);yawRef(t)+r0(3)];

% Approximate desired position and orientation using Euler's Approximation
x = zeros(size(t)); x(1) = p0(1);
y = zeros(size(t)); y(1) = p0(2);
z = zeros(size(t)); z(1) = p0(3);
roll = zeros(size(t)); roll(1) = r0(1);
pitch = zeros(size(t)); pitch(1) = r0(2);
yaw = zeros(size(t)); yaw(1) = r0(3);

for i = 2:numel(t)
x(i) = x(i-1) + dt*x_dot(t(i-1));
y(i) = y(i-1) + dt*y_dot(t(i-1));
z(i) = z(i-1) + dt*z_dot(t(i-1));
roll(i) = roll(i-1) + dt*roll_dot(t(i-1));
pitch(i) = pitch(i-1) + dt*pitch_dot(t(i-1));
yaw(i) = yaw(i-1) + dt*yaw_dot(t(i-1));

end

robot_dt = 0.001;
robot_t = 0:robot_dt:tf;
%simlastTime = 0;
q = zeros(6,length(robot_t)); q(:,1) = q0;
%Generate joint angles
% for i = 2:numel(t)
%     q(:,i) = getNextPosition(q(:,i-1),simlastTime,robot_dt,x_dot,y_dot,z_dot,...
%         roll_dot,pitch_dot,yaw_dot);
%     simlastTime = simlastTime + robot_dt
% end

num_steps = robot_dt/dt;
for i = 2:(numel(robot_t))
    fprintf('=============step %d=======================\n',i);
    k = (i-1)*num_steps;    %number to step forward
    P_i = posRef(:,k+1);  %position at time k. 
    
    RPY_i = angles(:,k+1);
    qnew = calculate_q(q(:,i-1),P_i,RPY_i)
%     if out_of_range(qnew)                         %SHOULD IMPLEMENT
%         fprintf('exceeded joint limits');
%         break;
%     end
    q(:,i) = qnew;
    
    %q_new = calculate_q(q_start, P_final, RPY_final)
end

%generate forward kinematics
FK_pos = zeros(3,length(robot_t));
for i=1:numel(robot_t)
    [R,P] = ForwardKinematics(q(:,i));
    FK_pos(:,i) = P;
end

%% Display computed trajectories
% Plot exact and approximate position functions
figure;
hold on;
plot(t,posRef(1,:),'--',t,posRef(2,:),'-.',t,posRef(3,:),':');
%plot(t,x,'-.',t,y,':',t,z,'--');
plot(robot_t,FK_pos(1,:),'o',robot_t,FK_pos(2,:),'o',robot_t,FK_pos(3,:),'o');
title('End Effector Position');
legend('$x_{exact}$','$y_{exact}$','$z_{exact}$',...
    'x_fk','y_fk','z_fk');
    %'$x_{approx}$','$y_{approx}$','$z_{approx}$');
% Plot exact and approximate orientation functions
  figure;
  hold on;
  plot(t,angles(1,:),'--',t,angles(2,:),'-.',t,angles(3,:),':');
  plot(t,roll,'-.',t,pitch,':',t,yaw,'--');
  title('End Effector Rotation');
  legend('$roll_{exact}$','$pitch_{exact}$','$yaw_{exact}$',...
      '$roll_{approx}$','$pitch_{approx}$','$yaw_{approx}$');
% Plot errors 
% figure;
% hold on;
% plot(t,pos(1,:)-x,t,pos(2,:)-y,t,pos(3,:)-z);
% title('Position error');
% figure;
% hold on;
% plot(t,angles(1,:)-roll,t,angles(2,:)-pitch,t,angles(3,:)-yaw);
% title('Orientation error');

%plot angles
figure;
hold on
title('Joint Angles');
plot(robot_t,q(1,:),robot_t,q(2,:),robot_t,q(3,:),robot_t,q(4,:),robot_t,q(5,:),robot_t,q(6,:));
legend('q1','q2','q3','q4','q5','q6');
% Visualise trajectory
% figure;
% for i = 1:1000:numel(t)
%     pi = pos(:,i);
%     
%     % To get transformation matrix from initial to final frame
%     % Rt0 = RtI*RI0
%     Rt0 = RPY(roll(i),pitch(i),yaw(i))*RI0;
%     plotCurrentFrame(p0,pi,pf,RI0,Rt0);
% end