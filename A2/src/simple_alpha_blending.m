src = imread('../img/fish.jpg');
dst = imread('../img/underwater.jpg');

w = size(src, 1);
h = size(src, 2);

mask = zeros(w, h);

cx = 650;
cy = 750;
r  = 250;

for i = cx-r:cx+r
    for j = cy-r:cy+r
        if incircle(cx, cy, r, i, j)
            mask(i, j) = (1 - dist(cx, cy, i, j)/r);
        end
    end
end
   
for i = 1:w
    for j = 1:h
        dst(i, j, :) = mask(i, j)*src(i, j, :) + (1-mask(i, j))*dst(i, j, :);
    end
end

imshow(dst);
