src = imread('fish.jpg');
dst = imread('underwater.jpg');

src_width = size(src, 1);
src_height = size(src, 2);

offset_i = 400;
offset_j = 400;

mask = zeros(src_width, src_height);

cx = 250;
cy = 350;
r  = 250;

for i = 1:src_width
    for j = 1:src_height
        if incircle(cx, cy, r, i, j)
            mask(i, j) = (1 - dist(cx, cy, i, j)/r);
        end
    end
end
   
for i = 1:src_width
    for j = 1:src_height
        dst(i+offset_i, j+offset_j, :) = mask(i, j)*src(i, j, :) + (1-mask(i, j))*dst(i+offset_i, j+offset_j, :);
    end
end

imshow(dst);