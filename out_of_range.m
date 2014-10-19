function [outside,joints] = out_of_range(qnew,min_angle,max_angle)
    outside = false;
    joints = [0 0 0 0 0 0];
    %  use these as angle constraint overrides for better range of motion
    %  in simulation.
    %max_angle = [360,360,360,360,360,360];
    %min_angle = [-360,-360,-360,-360,-360,-360];
    for i=1:6
        q = qnew(i);
        if q>max_angle(i)
            outside = true;
            %fprintf('q%d = %3.2f, exceeds max of %3.2f\n',i,q,max_angle(i));
            joints(i) = 1;
        elseif q<min_angle(i)
            outside = true;
            %fprintf('q%d = %3.2f, exceeds min of %3.2f\n',i,q,min_angle(i));
            joints(i) = 1;
        end
    end
end