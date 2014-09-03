% See ../README.md for details

%%%% CONSTANTS %%%%%%%%
% Current folder and image being read
FOLDER = '4';
IM_NAME = 'original.jpg'

% Shift % range searched (0.0 ~ 1.0)
max_shift = 0.08;

% Shift points samples (10 ~ 100)
shift_pts = 20;
%%%%%%%%%%%%%%%%%%%%%%%

% Read image and convert to double
img = imread(fullfile('../img/', FOLDER, IM_NAME));
img = im2double(img);

% Crop the image horizontally into the 3 images
[height, width] = size(img);

third = floor(height/3);

blue   = img(1:(third), :);
green  = img((third+1):(2*third), :);
red    = img((2*third+1):(3*third), :);

% Naive approach
naive = cat(3, red, green, blue);
imwrite(naive, fullfile('../img/', FOLDER, '/naive.jpg'));


% SSD approach

shifted_green = im_align(blue, green, max_shift, shift_pts);
shifted_red   = im_align(blue, red,   max_shift, shift_pts);

result = cat(3, shifted_red, shifted_green, blue);

imwrite(result, fullfile('../img', FOLDER, '/result.jpg'));
