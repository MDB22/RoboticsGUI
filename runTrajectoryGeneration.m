% Helper function to run TrajectoryGeneration from Processing

clc;
close all;

q = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];

[RI0, p0] = ForwardKinematics(q);
RPY = @(roll,pitch,yaw)(rotx(roll)*roty(pitch)*rotz(yaw));

pf = [X;Y;Z];
qf = [Roll;Pitch;Yaw];

if (exist('Time','var') == 1 && Time ~= 0)
    tf = Time;
else
    tf = 10;
end

[~,~,~,x_dot,y_dot,z_dot,~,~,~,roll_dot,pitch_dot,yaw_dot]...
    = TrajectoryGeneration(q,pf,qf,tf);