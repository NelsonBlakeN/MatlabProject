function [] = Project_Regression(reg)
    
    s = size(reg);
    if(s(2) == 2)
        x = reg(:, 1);
        y = reg(:, 2);

        order = menu('What is the order of regression?', 'Linear', 'Quadratic', 'Cubic');
        p = polyfit(x, y, order);

        switch order
            case 1
                yfit = p(1)*x + p(2);
                plot(x, y, 'rd', x, yfit, 'b--')
            case 2
                yfit = p(1)*x.^2 + p(2)*x + p(3);
                plot(x, y, 'rd', x, yfit, 'b--')
            case 3
                yfit = p(1)*x.^3 + p(2)*x.^2 + p(3)*x + p(4);
                plot(x, y, 'rd', x, yfit, 'b--')
            otherwise
        end

    else
        disp('This data is confusing so we''re not plotting it kthx')
    end
end