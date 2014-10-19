clc;
q0 = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];

[RI0, p0] = ForwardKinematics(q0);
RPY = @(roll,pitch,yaw)(rotx(roll)*roty(pitch)*rotz(yaw));

pf = [X;Y;Z];
rf = [Roll;Pitch;Yaw];

if (exist('Time','var') == 1 && Time ~= 0)
    tf = Time;
else
    tf = 10;
end
tf = 0.1;



% Find final orientation of end effector given rotation matrix RI0
yawf = atan2(RI0(2,1),RI0(1,1));
pitchf = atan2(-RI0(3,1),sqrt(RI0(3,2)^2 + RI0(3,3)^2));
rollf = atan2(RI0(3,2),RI0(3,3));
r0 = rad2deg([rollf;pitchf;yawf]);      %initial orientation

[xRef,yRef,zRef,xRef_dot,yRef_dot,zRef_dot,rollRef,pitchRef,...
    yawRef,rollRef_dot,pitchRef_dot,yawRef_dot]...
    = TrajectoryGeneration(q0,pf,rf,tf);

dt = .001;
t = 0:dt:tf;
tfsettle = 0.05;
tsettle = (tf+dt):dt:(tf+tfsettle);

% Exact desired position and orientation
posRef = [xRef(t);yRef(t);zRef(t)];
angles = [rollRef(t);pitchRef(t);yawRef(t)];    %[rollRef(t)+r0(1);pitchRef(t)+r0(2);yawRef(t)+r0(3)];  %absolute orientation
qfinal = calculate_q(q0,pf,rf);

for i=length(t)+1:1:(length(t)+length(tsettle))
    posRef(:,i) = pf;
    angles(:,i) = rf;
end


robot_dt = 0.001;
robot_t = 0:robot_dt:(tf+tfsettle);
q_array = zeros(6,length(robot_t)); q_array(:,1) = q0;
q0;

num_steps = robot_dt/dt;
outside = false;
total_trans_error = 0;
sum_error = [0;0;0;0;0;0];


q_final = find_valid_q(pf, rf,min_angle,max_angle);
if (q_final == false)
    outside = true;
    fprintf('no valid solution found');
else
    q_array = angleTrajectory(q0,q_final,length(robot_t));
    for i=1:length(q_array)
        [R_new, P_new] = ForwardKinematics(q_array(:,i));
        xyz(:,i) = P_new;
    end
end

close all
figure;
plot(robot_t,xyz(1,1:length(robot_t)),robot_t,xyz(2,1:length(robot_t)),robot_t,xyz(3,1:length(robot_t)));
title('position using p2p control');

 figure;
 plot(robot_t,q_array(1,:),'-o',robot_t,q_array(2,:),'-o',robot_t,q_array(3,:),'-o',robot_t,q_array(4,:),...
     '-o',robot_t,q_array(5,:),'-o',robot_t,q_array(6,:),'-o');
 title('joint angles using p2p control')
 legend('q1','q2','q3','q4','q5','q6');
