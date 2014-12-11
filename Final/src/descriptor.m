function [ features ] = descriptor(im, h_bins, s_bins, v_bins)
%DESCRIPTOR 
% takes a color image
% returns our descriptor of the image

    mask = get_mask(im);
    features = get_hist(im, mask, h_bins, s_bins, v_bins);

end

function [mask] = get_mask(im)
%GET_MASK
% takes a color image
% returns `mask`, a matrix with the same size as the image
%  where each i,j represents the mask region number that 
%  that pixel is in

    [h, w, colors] = size(im);

    cy = fix(h/2);
    cx = fix(w/2);
    
    % generate ellipse mask, 
    % taken from http://stackoverflow.com/q/11079781/2085107
    c = [cy cx];   %# Ellipse center point (y, x)
    r_sq = [cx*0.75, cy*0.75] .^ 2;  %# Ellipse radii squared (y-axis, x-axis)
    [X, Y] = meshgrid(1:size(im, 2), 1:size(im, 1));
    ellipse = (r_sq(2) * (X - c(2)) .^ 2 + r_sq(1) * (Y - c(1)) .^ 2 <= prod(r_sq));
    % end generate ellipse
    
    not_ellipse = ~ellipse;
    
    % here is where the magic happens
    % these poly2mask calls build rectangles in the four quadrants of the
    % image. AND-ing them with ~ellipse excludes the ellipse region from
    % the rectangle. Multiplying element-wise by 2,3,4,5 allows us to
    % differentiate the region the pixel is in. 
    
    mask = ellipse ...
        + ((poly2mask([cx cx w w cx], [0 cy cy 0 0], h, w) & not_ellipse) .* 2) ...
        + ((poly2mask([0 0 cx cx 0], [0 cy cy 0 0], h, w) & not_ellipse) .* 3) ...
        + ((poly2mask([0 0 cx cx 0], [cy h h cy cy], h, w) & not_ellipse) .* 4) ...
        + ((poly2mask([cx cx w w 0], [cy h h cy cy], h, w) & not_ellipse) .* 5);
end

function [hist] = get_hist(im, mask, h_bins, s_bins, v_bins)
    [h, w, colors] = size(im);
    im = rgb2hsv(im);
    
    hist = zeros(5, h_bins, s_bins, v_bins);
    
    hh = fix(im(:,:,1) .* (h_bins-1) + 1);
    ss = fix(im(:,:,2) .* (s_bins-1) + 1);
    vv = fix(im(:,:,3) .* (v_bins-1) + 1);

    for i=1:h
        for j=1:w
            hist(mask(i,j), hh(i,j), ss(i,j), vv(i,j)) = 1 + hist(mask(i,j), hh(i,j), ss(i,j), vv(i,j));
        end
    end
    
    for i=1:5
        temp = hist(i,:,:,:);
        hist(i,:,:,:) = temp / max(temp(:));
    end
    
    hist = hist(:);
end