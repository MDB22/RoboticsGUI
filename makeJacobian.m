clc;
clear all;

syms alpha alpha0 alpha1 alpha2 alpha3 alpha4 alpha5;
syms a a0 a1 a2 a3 a4 a5;
syms t t1 t2 t3 t4 t5 t6;
syms d d1 d2 d3 d4 d5 d6;
syms q1 q2 q3 q4 q5 q6;

alphaCell = {alpha0 alpha1 alpha2 alpha3 alpha4 alpha5};
aCell = {a0 a1 a2 a3 a4 a5};
dCell = {d1 d2 d3 d4 d5 d6};
tCell = {t1 t2 t3 t4 t5 t6};

% Initialise the Jacobian matrix
dimTaskSpace = 6;
dimJointSpace = 6;
z = [];
r = [];

% Angle about Xi-1 to align Zi-1 to Zi
Rx(alpha) = symfun([1 0 0 0;...
            0 cos(alpha) -sin(alpha) 0;...
            0 sin(alpha) cos(alpha) 0;...
            0 0 0 1],alpha);
        
% Distance along Xi-1 to align origins of i-1 and i        
Dx(a) = symfun([1 0 0 a;...
                0 1 0 0;...
                0 0 1 0;
                0 0 0 1],a);
            
% Angle about Zi to align Xi-1 and i
Rz(t) = symfun([cos(t) -sin(t) 0 0;...
                sin(t) cos(t) 0 0;...
                0 0 1 0;...
                0 0 0 1],t);

% Distance along Zi to align origins of i-1 and i
Dz(d) = symfun([1 0 0 0;...
                0 1 0 0;...
                0 0 1 d;
                0 0 0 1],a);

Ttotal = symfun(eye(4),[alpha a t d]);
for i = 6:-1:1
    % riE in frame i is simply Ttotal*rE
    R = Ttotal(alpha,a,t,d);
    r = [[R(1:3,4);0] r];
    
    % Transformation from frame i to i-1
    T = Rx(alphaCell{i})*Dx(aCell{i})*Rz(tCell{i})*Dz(dCell{i});    
    % Transformation from E to i-1
    Ttotal = T*Ttotal;
end

% Total transformation matrix
Ttotal = symfun(eye(4),[alpha a t d]);
for i = 1:6
    % Transfomation from frame i to i-1
    T = Rx(alphaCell{i})*Dx(aCell{i})*Rz(tCell{i})*Dz(dCell{i});    
    %  Transformation from i to 0
    Ttotal = Ttotal*T;
    
    % zi in frame i is simply T(1:3,3)
    % zi in frame 0 is simply Z(1:3,3)
    Z = Ttotal(alpha,a,t,d);
    z = [z Z(1:3,3)];
    
    % We also need riE in frame 0
    r(:,i) = Ttotal*r(:,i);
end

% DH Parameters
alpha = degtorad([0,90,0,90,-90,90]);
a = [0,11,130,0,0,4];
d = [78,0,18.5,127,3,98];
theta = degtorad([q1,q2,q3,q4,q5,q6]+[-180,90,90,0,0,0]);

% Local z axis vectors after substituting DH Parameters
z = subs(z,{alpha0,alpha1,alpha2,alpha3,alpha4,alpha5},alpha);
z = subs(z,{a0,a1,a2,a3,a4,a5},a);
z = subs(z,{d1,d2,d3,d4,d5,d6},d);
z = subs(z,{t1,t2,t3,t4,t5,t6},theta);

% Origin-to-end-effector vectors after substituting DH Parameters
r = subs(r,{alpha0,alpha1,alpha2,alpha3,alpha4,alpha5},alpha);
r = subs(r,{a0,a1,a2,a3,a4,a5},a);
r = subs(r,{d1,d2,d3,d4,d5,d6},d);
r = subs(r,{t1,t2,t3,t4,t5,t6},theta);

% Forward Kinematics relationship after substituting DH Parameters
Ttotal = subs(Ttotal,{alpha0,alpha1,alpha2,alpha3,alpha4,alpha5},alpha);
Ttotal = subs(Ttotal,{a0,a1,a2,a3,a4,a5},a);
Ttotal = subs(Ttotal,{d1,d2,d3,d4,d5,d6},d);
Ttotal = subs(Ttotal,{t1,t2,t3,t4,t5,t6},theta);

% Now we can compute the columns of the Jacobian
for i = 1:6
    Jacobian(1:6,i) = [cross(z(:,i),r(1:3,i)) ; z(:,i)];
end
save('Ttotal.mat','Ttotal');
save('Jacobian.mat','Jacobian');