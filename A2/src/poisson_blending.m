src = imread('../img/fish.jpg');
dst = imread('../img/underwater.jpg');

w = size(src, 1);
h = size(src, 2);

mask = zeros(w, h);

mask(450:850, 550:1000) = 1;

for i = 1:dst_width
    for j = 1:dst_height
        if mask(i, j)
            dst(i, j, :) = src(i, j, :);
        end
    end
end

imwrite(dst, '../img/binary.jpg');
