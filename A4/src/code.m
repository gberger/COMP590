%%%%%%%%% CONFIG
FOLDER = '2';
IMAGES = 4;
%%%%%%%%%%%%%%%%

% read the 1st image
result = im2double(imread(strcat('../img/', FOLDER, '/0.jpg')));

for j = 1 : (IMAGES-1)
    % read the 2nd, 3rd etc image
    im = im2double(imread(strcat('../img/', FOLDER, '/' , num2str(j), '.jpg')));
    
    %%%%%%%%% IMPORTANT
    % swap the comment between the two lines below to use manual or auto 
    [pts1, pts2] = SIFT(result, im);
    % [pts1, pts2] = get_correspondences(result, im);
    
    H = calculate_homography(pts1, pts2);

    % Compute result
    I = maketform('affine', eye(3));    
    T = maketform('projective', H);

    % obtain x/y data
    [~, x_data, y_data] = imtransform(im, T, 'XYScale', 1);
    
    % update x/y data from the bounds
    x_data = [min(1, x_data(1)) max(size(result,2), x_data(2))];
    y_data = [min(1, y_data(1)) max(size(result,1), y_data(2))];
    
    % 
    im_t = imtransform(im, T, 'XData', x_data, 'YData', y_data, 'XYScale', 1);
    result = imtransform(result, I, 'XData', x_data, 'YData', y_data, 'XYScale', 1);
    result = result + im_t .* (result < 0.001);
    
    % show image
    figure
    imshow(result);
end
