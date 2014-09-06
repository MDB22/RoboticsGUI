function bigQuiver( X, Y, Z, U, V, W, scale )
%BIGQUIVER Summary of this function goes here
%   Detailed explanation goes here

h = quiver3(X, Y, Z, U, V, W);
adjust_quiver_arrowhead_size(h, scale);

end

