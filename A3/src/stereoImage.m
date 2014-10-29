%% Stereo Pinhole Camera assignment
% In this assignment, we took pictures with a pinhole camera. There were
% two pinholes in our camera, one covered with a red filter, and another
% with a blue filter. We aligned the images to create a color, stereo
% image. Then we compared points in both images to determine their depth in
% the scene.
function [] = stereoImage(imagePath)
    %% Read in the image and apply corrections
    % Flip the image horizontally to correct light flip from pinhole. Then,
    % separate into color channels based on filters.
    image = flip(im2double(imread(imagePath)));
    red = image(:, :, 1);
    green = image(:, :, 2);
    blue = image(:, :, 3);
    %% Show the images
    plotN = 2;
    plotM = 3;
    shiftedRed = red;
    shiftedBlue = blue;
    figure(1);
    subplot(plotN, plotM, 1);
    imshow(shiftedRed);
    title('Red pinhole image');

    subplot(plotN, plotM, 2);
    imshow(shiftedBlue);
    title('Blue pinhole image');

    subplot(plotN, plotM, 3);
    imshow(green);
    title('?? pinhole image');

    %% Align the stereo pair
    % Use ginput to select corresponding points and shift the images to
    % line up with each other. Do this 'nAlignPts' times.
    nAlignPts = 3; % The number of points to use in the alignment (arbitrary)
    for i = 1 : nAlignPts
        subplot(plotN, plotM, 1);
        title('Select a red constraint point');
        [rx, ry] = ginput(1);
        title('');
        subplot(plotN, plotM, 2);
        title('Select the same point in the blue image');
        [bx, by] = ginput(1);
        title('');
        % shift the images
        dx = int32((rx - bx) / i);
        dy = int32((ry - by) / i);
        if (dx < 0)
            shiftedRed(:, 1-dx:end) = shiftedRed(:, 1:end+dx);
        else 
            shiftedBlue(:, 1+dx:end) = shiftedBlue(:, 1:end-dx);
        end
        if (dy < 0)
             shiftedRed(1-dy:end, :) = shiftedRed(1:end+dy, :);
        else
            shiftedBlue(1+dy:end, :) = shiftedBlue(1:end-dy, :);
        end
        % Show the shifted images
        subplot(plotN, plotM, 1);
        imshow(shiftedRed);
        title('Shifted red');
        subplot(plotN, plotM, 2);
        imshow(shiftedBlue);
        title('Shifted blue');
        % Show the aligned composite result
        aligned = zeros(size(image));
        aligned(:, :, 1) = shiftedRed(:, :);
        aligned(:, :, 2) = (shiftedRed + shiftedBlue) / 2;
        aligned(:, :, 3) = shiftedBlue(:, :);
        subplot(plotN, plotM, 4);
        imshow(aligned);
        title('Aligned');
    end
    
    %% Convert disparity to depth
    % Here we wanted to determine the distance of objects in the scene from
    % the camera (depth) by comparing the disparity between their positions
    % in the two stereo images.
    % The focal length and distance between the pinholes of our camera were
    % used in this calculation.
    % disparity = x - x' = baseline * f / z
    focalLength = 23; % cm
    baseline  = 4.23; % cm
    subplot(1, 2, 1);
    imshow(red);
    subplot(1, 2, 2);
    imshow(blue);
    numDistances = 3; % the number of measurements we want to take (arbitrary)
    for i = 1 : numDistances
        subplot(1, 2, 1);
        title('Select a point in this image');
        [rx, ry] = ginput(1);
        title('');
        subplot(1, 2, 2);
        title('Select a point in this image');
        [bx, by] = ginput(1);
        title('');
        % the distance in centimeters^2/pixel
        distance = focalLength * baseline / (sqrt((rx-bx)^2 + (ry-by)^2))
    end
end