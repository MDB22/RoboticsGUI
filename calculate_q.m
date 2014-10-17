%Calculates the new joint angles q which will produce the desired position
%and orientation.
function [q_new, error] = calculate_q(q_start, P_final, RPY_final)

R_final = rotx(RPY_final(1))*roty(RPY_final(2))*rotz(RPY_final(3));       %rotation matrix

[R_start, P_start] = ForwardKinematics(q_start);         %current position
P_start;

%get roll pitch yaw from rotation matrix
%roll_start = atand(R_start(2,1)/R_start(1,1));
%pitch_start = atand(-R_start(3,1)/sqrt(R_start(3,2)^2 + R_start(3,3)^2));
%yaw_start = atand(R_start(3,2)/R_start(3,3));

%getRoll = @(R) (atand(R_start(2,1)/R_start(1,1)));
%getPitch = @(R) (atand(-R_start(3,1)/sqrt(R_start(3,2)^2 + R_start(3,3)^2)));
%getYaw = @(R) (atand(R_start(3,2)/R_start(3,3)));

%getRPY = @(R) [getRoll(R); getPitch(R); getYaw(R)];

%RPY_start = getRPY(R_start);




error_translation = P_final - P_start;
error_orientation = get_error_orientation(R_final,R_start);

error = [error_translation; error_orientation];
q_new = q_start;

xyz = P_start;
num_iterations = 30;

for i=1:num_iterations;
    %fprintf('--------------------new iteration %d------------------------\n',i);
    Gain = [10;10;10;1;1;1];
    xc_dot = Gain.*error;            %xc_dot = Kp e
    
    J = ComputeJacobian(q_new);

    % Make sure we at least try to deal with singularities
    if (abs(det(J)) < .1)
        det_J = det(J);
        JInv = pinv(J);
    else
        JInv = inv(J);
    end
    
    dq = JInv*xc_dot;
    q_new = q_new+dq;
    [R_new, P_new] = ForwardKinematics(q_new);
    P_new;
    xyz(:,i+1)=P_new;
    
    error_translation = P_final - P_new;
    error_orientation = get_error_orientation(R_final,R_new);

    error = [error_translation; error_orientation];
    
    
end

% iteration = 0:num_iterations;
% figure;
% plot(iteration,xyz(1,:),iteration,xyz(2,:),iteration,xyz(3,:))
%error;
%fprintf('Pnew: [ %3.2f %3.2f %3.2f]', P_new(1), P_new(2), P_new(3));


end


%jacobian tells you which direction- around x0, y0, and z0 the joint
