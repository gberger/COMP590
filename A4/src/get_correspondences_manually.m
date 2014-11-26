function [ pts1, pts2 ] = get_correspondences_manually( im1, im2, n )
    figure;
    imshow(im1);
    title('Specify points for first image');
    pts1 = ginput(n);
    imshow(im2);
    title('Specify points for second image');
    pts2 = ginput(n);
end
