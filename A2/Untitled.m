src = imread('fish.jpg');
dst = imread('underwater.jpg');

src_width = size(src, 1);
src_height = size(src, 2);

offset_i = 400;
offset_j = 400;

mask = zeros(src_width, src_height);
mask(50:450, 150:600) = 1;

for i = 1:src_width
    for j = 1:src_height
        if mask(i, j)
            dst(i+offset_i, j+offset_j, :) = src(i, j, :);
        end
    end
end

imshow(dst);