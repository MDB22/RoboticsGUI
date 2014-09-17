function J = ComputeJacobian(q)
%COMPUTEJACOBIAN Summary of this function goes here
%   Detailed explanation goes here

Jacobian = @(q1,q2,q3,q4,q5,q6)...
    ([ cos((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)) + 37/2) - sin((pi*q1)/180)*(cos((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130) + sin((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))) + 11),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            cos((pi*q1)/180)*(cos((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))) - sin((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130)),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        cos((pi*q1)/180)*((cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + (3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                     - (cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))*((4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 3*cos((pi*q1)/180)*cos((pi*q4)/180) - (98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 3*sin((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) - (sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*((98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) + 3*sin((pi*q4)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                                                                                           - (cos((pi*q1)/180)*cos((pi*q4)/180) + sin((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)))*(4*sin((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) - 98*cos((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) + 4*cos((pi*q4)/180)*cos((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 98*cos((pi*q4)/180)*sin((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))) - sin((pi*q4)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*(4*cos((pi*q5)/180)*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*sin((pi*q5)/180)*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) - 98*cos((pi*q5)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 4*sin((pi*q5)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                                                                                                                                                                      0;
    cos((pi*q1)/180)*(cos((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130) + sin((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))) + 11) + sin((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)) + 37/2),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            sin((pi*q1)/180)*(cos((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))) - sin((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130)),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        sin((pi*q1)/180)*((cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + (3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                       (cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*((98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) + 3*sin((pi*q4)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))) - (cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))*((4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + (98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 3*cos((pi*q4)/180)*sin((pi*q1)/180) - 3*sin((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))),                                                                                                                                                                                                                                                                                           - (cos((pi*q4)/180)*sin((pi*q1)/180) - sin((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)))*(4*sin((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) - 98*cos((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)) + 4*cos((pi*q4)/180)*cos((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 98*cos((pi*q4)/180)*sin((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))) - sin((pi*q4)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*(4*cos((pi*q5)/180)*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*sin((pi*q5)/180)*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*cos((pi*q5)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - 4*sin((pi*q5)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                                                                                                                                                                      0;
    0, cos((pi*q1)/180)*(sin((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)) + 37/2) + cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130) + cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))))) + sin((pi*q1)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*(sin((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - cos((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + 130) - cos((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)) + 37/2) + sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*(cos((pi*(q3 + 90))/180)*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + sin((pi*(q3 + 90))/180)*(3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))))), cos((pi*q1)/180)*(sin((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) + (cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) - (3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) - sin((pi*q1)/180)*(cos((pi*q1)/180)*(3*cos((pi*q4)/180) + sin((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))) - (sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*(98*cos((pi*q5)/180) - 4*sin((pi*q5)/180) + 127) + (3*sin((pi*q4)/180) - cos((pi*q4)/180)*(4*cos((pi*q5)/180) + 98*sin((pi*q5)/180)))*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))), - (sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*((4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + (98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 3*cos((pi*q4)/180)*sin((pi*q1)/180) - 3*sin((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) - (cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))*((4*cos((pi*q5)/180) + 98*sin((pi*q5)/180))*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 3*cos((pi*q1)/180)*cos((pi*q4)/180) - (98*cos((pi*q5)/180) - 4*sin((pi*q5)/180))*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 3*sin((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))), (cos((pi*q1)/180)*cos((pi*q4)/180) + sin((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)))*(4*cos((pi*q5)/180)*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*sin((pi*q5)/180)*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*cos((pi*q5)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - 4*sin((pi*q5)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))) - (cos((pi*q4)/180)*sin((pi*q1)/180) - sin((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)))*(4*cos((pi*q5)/180)*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + 98*sin((pi*q5)/180)*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) - 98*cos((pi*q5)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) + 4*sin((pi*q5)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180))),                                                                                                                                                                                                                                                                                                                                                                      0;
    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      sin((pi*q1)/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        sin((pi*q1)/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          cos((pi*q4)/180)*sin((pi*q1)/180) - sin((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)), sin((pi*q5)/180)*(sin((pi*q1)/180)*sin((pi*q4)/180) + cos((pi*q4)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - cos((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))) + cos((pi*q5)/180)*(cos((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180));
    0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     -cos((pi*q1)/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -cos((pi*q1)/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        - cos((pi*q1)/180)*cos((pi*q4)/180) - sin((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)), cos((pi*q5)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + sin((pi*q1)/180)*cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - sin((pi*q5)/180)*(cos((pi*q1)/180)*sin((pi*q4)/180) - cos((pi*q4)/180)*(sin((pi*q1)/180)*cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*q1)/180)*sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180)));
    1,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) - cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               -sin((pi*q4)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)),                                                                                                           cos((pi*q4)/180)*sin((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180) + cos((pi*(q3 + 90))/180)*sin((pi*(q2 + 90))/180)) - cos((pi*q5)/180)*(cos((pi*(q2 + 90))/180)*cos((pi*(q3 + 90))/180) - sin((pi*(q2 + 90))/180)*sin((pi*(q3 + 90))/180))]);

J = Jacobian(q(1),q(2),q(3),q(4),q(5),q(6));
end

