function [ dist ] = comparator( a, b )
%COMPARATOR
%  

    dist = chi_squared_distance(a, b);
end

function [ d ] = chi_squared_distance(a, b)
    eps = 1e-10;
    d = sum(((a - b) .^ 2) ./ (a+b+eps));
end