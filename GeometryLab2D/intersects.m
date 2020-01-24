    function [LL, LC, CC] = intersects(lines, circles)    
    
    LL = [];
    LC = [];
    CC = [];

    %lines row size
    m = size(lines, 1);
    
    % lines intersection
    for i = 1:m - 1
        % x coordinates of first polyline
        lineX1 = [lines(i, 1) lines(i, 3)]';
        % y coordinates of second polyline
        lineY1 = [lines(i, 2) lines(i, 4)]';
        % points XY1 and point XY2 are end points of a line
        pointXY1 = [lines(i, 1) lines(i, 2)];
        pointXY2 = [lines(i, 3) lines(i, 4)];
        for j = i + 1:m
            lineX2 = [lines(j, 1) lines(j, 3)]';
            lineY2 = [lines(j, 2) lines(j, 4)]';
            pointXY3 = [lines(i, 1) lines(i, 2)];
            pointXY4 = [lines(i, 3) lines(i, 4)];
            %calculates and assigns the intersection point of 2 lines
            [xi, yi] = polyxpoly(lineX1, lineY1, lineX2, lineY2);
            p = [xi yi];
            if (size(p, 1) ~= 0) & (p ~= pointXY1) & (p ~= pointXY2) & (p ~= pointXY3) & (p ~= pointXY4)
                LL = [LL; p];
            end
        end
    end
   
    % circles row size
    cm = size(circles, 1);
    
    % circles and lines intersection
    for i = 1:cm
        center = [circles(i, 1) circles(i, 2)];
        r = circles(i, 3);
        for j = 1:m
            % line segment end points
            point1 = [lines(j, 1) lines(j, 2)]';
            point2 = [lines(j, 3) lines(j, 4)]';
            % x coordinates
            xs = [lines(j, 1) lines(j, 3)];
            % y coordinates
            ys = [lines(j, 2) lines(j, 4)];
            % explicit 2d line to parametric
            [f, g, x0, y0] = line_exp2par_2d(point1, point2);
            % gets the number of intersection points found and the
            % intersection point(s) of a line and circle
            [LCnum_int, LCp] = circle_imp_line_par_int_2d (r, center, x0, y0, f, g);

            % if intersection points found is not 0
            if LCnum_int ~= 0
                % lines and circles intersection points temp holder
                LCtemp = LCp';
                for i = 1:size(LCtemp, 1)
                    x1 = LCtemp(i, 1);
                    x2 = LCtemp(i, 2);
                    % checks if the intersection points found is in between
                    % the line segment end points, if so it appends this to LC
                    if (max(xs) >= x1) & (x1 >= min(xs))...
                            & (max(ys) >= x2) & (x2 >= min(ys))
                        LC = [LC; LCtemp(i, :)];
                    end
                end
            end
        end
    end

    % circles intersection
    for i = 1:cm - 1
        center1 = [circles(i, 1) circles(i, 2)];
        r1 = circles(i, 3);
        for j = i + 1:cm
            center2 = [circles(j, 1) circles(j, 2)];
            r2 = circles(j, 3);
            [CCnum_int, CCp] = circles_imp_int_2d (r1, center1, r2, center2);
            
            if (CCnum_int == 1) || (CCnum_int == 2)
                CC = [CC; CCp'];
            end
        end
    end
    
end
    