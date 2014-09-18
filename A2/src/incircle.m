function [ res ] = incircle( cx, cy, rad, px, py )
%INCIRCLE Summary of this function goes here
%   Detailed explanation goes here
    if dist(cx, cy, px, py) < rad
        res = true;
    else
        res = false;
    end
end

