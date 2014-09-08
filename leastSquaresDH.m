clc
clear all
syms a1 a2 a5 d1 d3 d4 d5 d6 t1 t2 t3 t4 t5 t6
equation = ...
[[d3*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) - d6*(sin(t5)*(cos(t3)*sin(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) + cos(t4)*sin(t3)*(cos(t1)*sin(t2) + cos(t2)*sin(t1))) - cos(t5)*(cos(t1)*cos(t2) - sin(t1)*sin(t2))) + d4*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) - d5*(cos(t3)*cos(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) - sin(t3)*sin(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1))) + a2*sin(t3)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) + a5*sin(t6)*(cos(t3)*cos(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) - sin(t3)*sin(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1))) - a1*cos(t1)*sin(t2) - a1*cos(t2)*sin(t1) + a5*cos(t6)*(cos(t5)*(cos(t3)*sin(t4)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) + cos(t4)*sin(t3)*(cos(t1)*sin(t2) + cos(t2)*sin(t1))) + sin(t5)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)))]
[d6*(sin(t5)*(cos(t3)*sin(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) + cos(t4)*sin(t3)*(cos(t1)*cos(t2) - sin(t1)*sin(t2))) + cos(t5)*(cos(t1)*sin(t2) + cos(t2)*sin(t1))) + d3*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) + d4*(cos(t1)*sin(t2) + cos(t2)*sin(t1)) + d5*(cos(t3)*cos(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) - sin(t3)*sin(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2))) - a2*sin(t3)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) + a1*cos(t1)*cos(t2) - a5*sin(t6)*(cos(t3)*cos(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) - sin(t3)*sin(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2))) - a1*sin(t1)*sin(t2) - a5*cos(t6)*(cos(t5)*(cos(t3)*sin(t4)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)) + cos(t4)*sin(t3)*(cos(t1)*cos(t2) - sin(t1)*sin(t2))) - sin(t5)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)))]
[d1 + d5*(cos(t3)*sin(t4) + cos(t4)*sin(t3)) + a2*cos(t3) - a5*sin(t6)*(cos(t3)*sin(t4) + cos(t4)*sin(t3)) - d6*sin(t5)*(cos(t3)*cos(t4) - sin(t3)*sin(t4)) + a5*cos(t5)*cos(t6)*(cos(t3)*cos(t4) - sin(t3)*sin(t4))]];

B = [a1;a2;a5;d1;d3;d4;d5;d6];
A = cell(length(equation),length(B));

for i = 1:length(equation)
    for j = 1:length(B)
        a = coeffs(equation(i),B(j));
        A{i,j} = a(length(a));
    end
end