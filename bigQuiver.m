function bigQuiver( X, Y, Z, U, V, W, scale )
%BIGQUIVER Summary of this function goes here
%   Detailed explanation goes here

if numel(X) > 1
    h = quiver3(X(1), Y(1), Z(1), U(1), V(1), W(1),'r');
    adjust_quiver_arrowhead_size(h, scale);
    h = quiver3(X(2), Y(2), Z(2), U(2), V(2), W(2),'g');
    adjust_quiver_arrowhead_size(h, scale);
    h = quiver3(X(3), Y(3), Z(3), U(3), V(3), W(3),'b');
    adjust_quiver_arrowhead_size(h, scale);
else
    h = quiver3(X, Y, Z, U, V, W);
    adjust_quiver_arrowhead_size(h, scale);
end

end

