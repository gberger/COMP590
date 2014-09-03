function y = ssd(a, b, exclude)
    aa = crop_center(a, exclude);
    bb = crop_center(b, exclude);
    y = sumsqr(bb - aa);
end
