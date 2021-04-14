function [x] = solver(f,df,x0,tol) 
    k = 2; 
    y(1) = x0 - (f(x0)/df(x0));
    y(2) = y(1) - (f(y(1)) / df(y(1)));
    while abs(y(k) - y(k - 1)) > tol
        k = k + 1;
        y(k) = y(k - 1) - (f(y(k - 1)) / df(y(k - 1))); 
    end
    x = y(k);
end
