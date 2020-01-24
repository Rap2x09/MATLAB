function transShapes = transformShapes(transMatrix, shape)
    
    %plotHolder = [];
    transShapes = [];
    
    if size(shape, 2) == 4
        %lines = shapeP;
        for i = 1: size(shape, 1)    
            p1 = transMatrix * [shape(i,1); shape(i,2)];
            p2 = transMatrix * [shape(i,3); shape(i,4)];
            % plotHolder = [plotHolder; plot([p1(1) p2(1)], [p1(2) p2(2)], 'k')];
            shape(i, :) = [p1' p2'];
        end
        %plotHolder = drawPolys(lines);
        transShapes = shape;
        
    elseif size(shape, 2) == 3
        %tempcirc = circles;
        % circs = circles;
        n = 360;
        for i = 1:size(shape, 1)
            circs = transMatrix * [shape(i,1); shape(i,2)];
            shape(i, 1) = circs(1);
            shape(i, 2) = circs(2);
        end
        transShapes = shape;
    end
end

