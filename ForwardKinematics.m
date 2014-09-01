function T = ForwardKinematics()

n_joints = 6;
T = eye(4);

%From inertial to top of rotated base
alpha0 = 0; a0 = 0; d1 = 78; theta1 = 0;

%From base to bottom of arm1
alpha1 = 90; a1 = 11; d2 = 0; theta2 = 90;

%From bottom of arm 1 to arm1/2 joint (elbow)
alpha2 = 0; a2 = 130; d3 = 18.5; theta3 = 90;

%From elbow to rotated end of arm3
alpha3 = 90; a3 = 0; d4 = 127; theta4 = 0;

%From end of arm3 to bottom of arm4
alpha4 = -90; a4 = 0; d5 = 3; theta5 = 0;

%From arm4 to rotated end effector
alpha5 = 90; a5 = 4; d6 = 64; theta6 = 0;

alpha = [alpha0, alpha1, alpha2, alpha3, alpha4, alpha5];
a = [a0, a1, a2, a3, a4, a5];
theta = [theta1, theta2, theta3, theta4, theta5, theta6];
d = [d1, d2, d3, d4, d5, d6];

for i = 1:n_joints
    Rx = [[rotx(alpha(i)) [0;0;0]] ; 0 0 0 1];
    Dx = [1 0 0 a(i); 0 1 0 0;0 0 1 0;0 0 0 1];
    Rz = [[rotz(theta(i)) [0;0;0]] ; 0 0 0 1];
    Dz = [1 0 0 0; 0 1 0 0;0 0 1 d(i);0 0 0 1];
    T = T * Rx * Dx * Rz * Dz;
end

end