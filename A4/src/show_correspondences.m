function [ ] = show_correspondences(im1, im2, pts1, pts2)
    figure
    imshow([im1 im2])
    title 'Correspondence between pair'
    
    offx = size(im1, 2);
    
    num = size(pts1, 1);
    
    for i=1:num
       line([pts1(i,1);pts2(i,1)+offx], [pts1(i, 2);pts2(i,2)], 'Color', 'Red')
    end
end

