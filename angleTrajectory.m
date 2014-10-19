function  Theta = angleTrajectory(StartAngle,EndAngle,numPoints)
    L = numPoints; %how many trajectory points
    Theta = [];
    for i = 1:6
     theta = (1:1:L).*(EndAngle(i)-StartAngle(i))/L+StartAngle(i);
     Theta = [Theta; theta];
    end
end