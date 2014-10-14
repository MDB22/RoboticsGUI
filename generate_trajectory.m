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

% Exact desired position and orientation
posRef = [xRef(t);yRef(t);zRef(t)];
angles = [rollRef(t)+r0(1);pitchRef(t)+r0(2);yawRef(t)+r0(3)];  %absolute orientation

robot_dt = 0.001;
robot_t = 0:robot_dt:tf;
q_array = zeros(6,length(robot_t)); q_array(:,1) = q0;

num_steps = robot_dt/dt;
for i = 2:(numel(robot_t))
    fprintf('=============step %d=======================\n',i);
    k = (i-1)*num_steps;    %number to step forward
    P_i = posRef(:,k+1);  %position at time k. 
    
    RPY_i = angles(:,k+1);
    qnew = calculate_q(q_array(:,i-1),P_i,RPY_i)
     if out_of_range(qnew)
         fprintf('exceeded joint limits\n');
         q_array(:,i) = q_array(:,i-1);         %keep at same position as before.
     else                                       %gives robot a chance to get back on track later.
         q_array(:,i) = qnew;
     end
    
end

close all
plot(t,xRef(t),t,yRef(t),t,zRef(t));
title('Position');
legend('xref','yref','zref');
figure;
plot(robot_t,q_array(1,:),robot_t,q_array(2,:),robot_t,q_array(3,:),robot_t,q_array(4,:),...
    robot_t,q_array(5,:),robot_t,q_array(6,:));
title('joint angles')
legend('q1','q2','q3','q4','q5','q6');