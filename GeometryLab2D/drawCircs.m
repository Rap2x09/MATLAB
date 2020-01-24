% Code to plot a circle
% taken from CM2104: Computational Mathematics 
% Laboratory Worksheet (Week 8) Reference Solutions
% by Dr. Y. Lai, Dr. R. Booth

function plotHolder = drawCircs(circles)
    
    plotHolder = [];
    n = 360;
    for c = 1:size(circles, 1)
        for i = 1: n + 1
            theta = ( 2.0 * pi * ( i -1 )) / n;
            p(1,i) = circles(c, 1) + circles(c, 3) * cos ( theta);
            p(2,i) = circles(c, 2) + circles(c, 3) * sin ( theta);
        end
        plotHolder = [plotHolder; plot(p(1, :), p(2, :), '-')];
    end
end