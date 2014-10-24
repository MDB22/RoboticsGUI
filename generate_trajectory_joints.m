q_final = [q_final0;q_final1;q_final2;q_final3;q_final4;q_final5];



clc;
q0 = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];

[RI0, p0] = ForwardKinematics(q0);

tf = 0.1;

dt = .001;
t = 0:dt:tf;
tfsettle = 0.05;
tsettle = (tf+dt):dt:(tf+tfsettle);

robot_dt = 0.001;
robot_t = 0:robot_dt:(tf+tfsettle);
q_array = zeros(6,length(robot_t)); q_array(:,1) = q0;

num_steps = robot_dt/dt;
outside = false;
total_trans_error = 0;
sum_error = [0;0;0;0;0;0];

xyz = p0;

q_array = angleTrajectory(q0,q_final,length(robot_t));
for i=1:length(q_array)
        [R_new, P_new] = ForwardKinematics(q_array(:,i));
        xyz(:,i) = P_new;
end


% close all
 figure;
 plot(robot_t,xyz(1,1:length(robot_t)),robot_t,xyz(2,1:length(robot_t)),robot_t,xyz(3,1:length(robot_t)));
 title('position using p2p control');
% 
  figure;
  plot(robot_t,q_array(1,:),'-o',robot_t,q_array(2,:),'-o',robot_t,q_array(3,:),'-o',robot_t,q_array(4,:),...
      '-o',robot_t,q_array(5,:),'-o',robot_t,q_array(6,:),'-o');
  title('joint angles using p2p control')
  legend('q1','q2','q3','q4','q5','q6');
