function qNew = getNextPosition(q0,lastTime,dt,x_dot,y_dot,z_dot,...
    roll_dot,pitch_dot,yaw_dot)
%getNextPosition Gets next joint angles for robot.
%   Given the currentTime, lastTime, and velocity profiles for position and 
%   orientation, uses Euler approximation to generate the robot joint
%   angles for the next iteration.

% Convert to seconds
lastTime = lastTime/1000
dt = dt/1000

taskSpaceVelocities = [
    x_dot(lastTime);
    y_dot(lastTime);
    z_dot(lastTime);
    roll_dot(lastTime);
    pitch_dot(lastTime);
    yaw_dot(lastTime);
    ]

J = ComputeJacobian(q0);

% Make sure we at least try to deal with singularities
if (det(J) < .1)
    JInv = pinv(J)
else
    JInv = inv(J)
end

% Compute joint space velocities: q_dot = J^-1 * x_dot
jointSpaceVelocities = JInv*taskSpaceVelocities

qNew = q0 + dt*jointSpaceVelocities;

end

