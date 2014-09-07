% Helper function to run TrajectoryGeneration.m from Processing without
% having to run all the extra commands
q = [qBase;qShoulder;qElbow;qWristRoll;qWristPitch;qWristYaw];

pf = [X;Y;Z];

qf = [Roll;Pitch;Yaw];

tf = Time;

trajectory = TrajectoryGeneration(q,pf,qf,tf);