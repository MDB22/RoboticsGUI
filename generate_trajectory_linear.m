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
%outside = out_of_range(qfinal,min_angle,max_angle);

% if out_of_range(qfinal,min_angle,max_angle)
%     fprintf('final q out of range\n')
%     inrange = false;
%     for rollnew = -180:20:180
%         rollnew
%         for pitchnew = -180:20:180
%             pitchnew
%             for yawnew = -180:20:180
%                 yawnew
%                 qfinal = calculate_q(q0,pf,[rollnew;pitchnew;yawnew])
%                 if (~out_of_range(qfinal,min_angle,max_angle))
%                     inrange = true;
%                     break;
%                 end
%             end
%             if inrange
%                 break;
%             end
%         end
%         if inrange
%             break;
%         end
%     end
% end
% 

robot_dt = 0.001;
robot_t = 0:robot_dt:(tf+tfsettle);
q_array = zeros(6,length(robot_t)); q_array(:,1) = q0;
q0;

num_steps = robot_dt/dt;
outside = false;
total_trans_error = 0;
sum_error = [0;0;0;0;0;0];

%% Trying Proportional method

q_new = q0;
error = [0;0;0;0;0;0];
xyz = p0;

for i=2:(numel(robot_t))
    %fprintf('--------------------step %d------------------------\n',i);
    k = (i-1)*num_steps;
    k_prev = (i-2)*num_steps;
    P_i = posRef(:,k+1);
    P_prev = posRef(:,k_prev+1);
    P_dot = (P_i - P_prev)/robot_dt;               %difference in position
    
    RPY_i = angles(:,k+1);
    RPY_prev = angles(:,k_prev+1);
    RPY_dot = (RPY_i - RPY_prev)/robot_dt;
    
    
    R_i = rotx(RPY_i(1))*roty(RPY_i(2))*rotz(RPY_i(3));     %reference rotation matrix
    
    xc_ref_dot = [P_dot; RPY_dot];                  %reference velocity
    Gain = [5000;5000;5000;1000;1000;1000];
    %if ((i>100)&&(total_trans_error < 2))
    %    Gain = 0.5*Gain;
    %end
    
    xc_dot = xc_ref_dot + 0.5*Gain.*error + 0*sum_error;            %xc_dot = Kp e
    
    J = ComputeJacobian(q_new);

    % Make sure we at least try to deal with singularities
    if (abs(det(J)) < .1)
        det_J = det(J);
        JInv = pinv(J);
    else
        JInv = inv(J);
    end
    
    dq = JInv*xc_dot*robot_dt;
    qnew_potential = q_array(:,i-1)+dq;
    q_array(:,i) = qnew_potential;
    [current_out, joints] = out_of_range(qnew_potential,min_angle,max_angle);
    for joint=1:6
        if joints(joint)==1 %means out of range.
            outside = true;                         %at end will tell if final position in range.
            q_array(joint,i) = q_array(joint,i-1);  %use previous value for that joint.
            fprintf('exceeded joint %d limits, not implemented.\n',joint);
        end
    end
    
    if total_trans_error>600                                       %gives robot a chance to get back on track later.
         fprintf(' error too large, likely unreachable. not implemented.\n'); 
         q_array(:,i) = q_array(:,i-1);
    else
        outside = false;
    end
    qnew = q_array(:,i);
    [R_new, P_new] = ForwardKinematics(q_array(:,i));
    P_new;
    xyz(:,i)=P_new;
    
    error_translation = P_i - P_new;
    total_trans_error = abs(error_translation(1))+abs(error_translation(2))+abs(error_translation(3))
    error_orientation = get_error_orientation(R_i,R_new);

    error = [error_translation; error_orientation];
    sum_error = sum_error+error;

end

%%
close all
figure;
plot(robot_t,xyz(1,1:length(robot_t)),robot_t,xyz(2,1:length(robot_t)),robot_t,xyz(3,1:length(robot_t)));
title('position using P control');

 figure;
 plot(robot_t,q_array(1,:),'-o',robot_t,q_array(2,:),'-o',robot_t,q_array(3,:),'-o',robot_t,q_array(4,:),...
     '-o',robot_t,q_array(5,:),'-o',robot_t,q_array(6,:),'-o');
 title('joint angles using P control')
 legend('q1','q2','q3','q4','q5','q6');




% 
% %%  This is the first way- calculate the 'perfect' position.
% for i = 2:(numel(robot_t))
%     fprintf('=============step %d=======================\n',i);
%     k = (i-1)*num_steps;    %number to step forward
%     P_i = posRef(:,k+1);  %position at time k. 
%     
%     RPY_i = angles(:,k+1);
%     qnew_potential = calculate_q(q_array(:,i-1),P_i,RPY_i)
%     if out_of_range(qnew_potential,min_angle,max_angle)
%         outside = true;                         %at end will tell if final position in range.
%         fprintf('exceeded joint limits\n');
%         q_array(:,i) = q_array(:,i-1);         %keep at same position as before.
%     else                                       %gives robot a chance to get back on track later.
%         outside = false;
%         q_array(:,i) = qnew_potential;
%     end
%     qi = q_array(:,i)
%     
% end
% 
% 
% q_array_filtered = q_array;
% %implement a moving average to remove large angle jumps
% q_array_filtered(:,2) = (q_array(:,1)+q_array(:,2)+q_array(:,3))/3;
% for i=3:length(q_array)-2
%     q_array_filtered(:,i) = (q_array(:,i-2)+q_array(:,i-1)+q_array(:,i)+q_array(:,i+1)+q_array(:,i+2))/5;
% end
% 
% %
% % qfinal
% % 
%  %close all
%  figure;
%  plot(t,xRef(t),t,yRef(t),t,zRef(t));
%  title('Position');
%  legend('xref','yref','zref');
%  figure;
%  plot(t,angles(1,:),t,angles(2,:),t,angles(3,:));
%  title('Orientation');
%  legend('rollref','pitchref','yawref');
%  figure;
%  plot(robot_t,q_array(1,:),'-o',robot_t,q_array(2,:),'-o',robot_t,q_array(3,:),'-o',robot_t,q_array(4,:),...
%      '-o',robot_t,q_array(5,:),'-o',robot_t,q_array(6,:),'-o');
%  title('joint angles')
%  legend('q1','q2','q3','q4','q5','q6');
%  
%   figure;
%  plot(robot_t,q_array_filtered(1,:),'-o',robot_t,q_array_filtered(2,:),'-o',robot_t,q_array_filtered(3,:),'-o',robot_t,q_array_filtered(4,:),...
%      '-o',robot_t,q_array_filtered(5,:),'-o',robot_t,q_array_filtered(6,:),'-o');
%  title('filtered joint angles')
%  legend('q1','q2','q3','q4','q5','q6');
%  
%  q_array = q_array_filtered;