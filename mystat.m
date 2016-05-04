function [mea, med, mod, va, stdev, mi, ma, counter, msg] = mystat(X)
    mea = mean(X);
    med = median(X);
    mod = mode(X);
    va = var(X);
    mi = min(X);
    ma = max(X);
    counter = 0;
    for i = 1:length(X)
        counter = counter + 1;
    end
    if counter > 30
        stdev = std(X);
        msg = '(Population Standard Deviation)';
    else
        stdev = std(X, 1);
        msg = '(Sample Standard Deviation)';
    end
end
