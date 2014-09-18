src = imread('../img/fish.jpg');
dst = imread('../img/underwater.jpg');

w = size(src, 1);
h = size(src, 2);

load('mask_alpha.mat');

for i = 1:w
    for j = 1:h
        dst(i, j, :) = mask(i, j)*src(i, j, :) + (1-mask(i, j))*dst(i, j, :);
    end
end

imwrite(dst, '../img/alpha.jpg');
