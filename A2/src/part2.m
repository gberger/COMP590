src = im2double(imread('../img/fish-small.jpg'));
dst = im2double(imread('../img/underwater-small.jpg'));

w = size(src, 1);
h = size(src, 2);
sz = [w h];
total = w*h;

im2var = zeros(w, h); 
im2var(1:total) = 1:total; 

load('mask-small.mat');

A = speye(total, total);

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
for i = 1:w
    for j = 1:h
        px = im2var(i, j);
        if mask(px)
           A(px, px) = 4;
           A(px, im2var(i+1, j)) = -1;
           A(px, im2var(i-1, j)) = -1;
           A(px, im2var(i, j+1)) = -1;
           A(px, im2var(i, j-1)) = -1;
        end
    end
end

res = zeros(w, h, 3);

for color = 1:3
    grad = conv2(src(:,:,color), laplacian, 'same');
    b = zeros(total, 1);
    for i = 1:w
       for j = 1:h
           px = im2var(i, j);
           if mask(px)
              b(px) = grad(i, j); 
           else
              b(px) = dst(i, j, color);
           end
       end
    end
    x = A\b;
    x = reshape(x, w, h);
    res(:, :, color) = x;
end

imwrite(res, '../img/poisson.jpg');
