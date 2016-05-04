function [] = Project_Regression(reg)
    s = size(reg);
    if(s(2) == 2)
        x = reg(:, 1);
        y = reg(:, 2);

        order = menu('What is the order of regression?', 'Linear', 'Quadratic', 'Cubic');
        p = polyfit(x, y, order);

        %BUG: If the 'X' button is pressed, it will enter the 'otherwise'
        %condition, which will then throw an error in the plot function.
        %Consider adding a try/catch to the plot fucntion, and possibly a
        %loop soemwhere.
        switch order
            case 1
                yfit = p(1)*x + p(2);
            case 2
                yfit = p(1)*x.^2 + p(2)*x + p(3);
            case 3
                yfit = p(1)*x.^3 + p(2)*x.^2 + p(3)*x + p(4);
            otherwise
                fprintf('This can''t even happen tf')
        end

        plot(x, y, 'rd', x, yfit, 'b--')
    else
        disp('This data is confusing so we''re not plotting it kthx')
    end
end