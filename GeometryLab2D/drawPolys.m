function plotHolder = drawPolys(lines)
    
    plotHolder = [];

    hold on
    for i = 1: size(lines, 1)
        plotHolder = [plotHolder; plot([lines(i,1) lines(i,3)], [lines(i, 2) lines(i, 4)], 'k')];
    end
    
end