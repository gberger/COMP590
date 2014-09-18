im = rgb2gray(im2double(imread('../img/toygc.png')));

h = size(im, 1); 
w = size(im, 2);
total = h*w;

im2var = zeros(h, w); 
im2var(1:total) = 1:total; 

A = sparse(total*2+1, total);
b = zeros(total*2+1, 1);

s = im;

e = 1;
A(e, im2var(1,1))=1; 
b(e)=s(1,1); 
for i = 1:(h-1)
    for j = 1:(w-1)
        e = e+1;
        A(e, im2var(i, j+1)) = 1;
        A(e, im2var(i, j))   = -1;
        b(e) = s(i, j+1) - s(i, j);
        
        e = e+1;
        A(e, im2var(i+1, j)) = 1;
        A(e, im2var(i, j))   = -1;
        b(e) = s(i+1, j) - s(i, j);
    end
end

v = A\b;
v = reshape(v, h, w);
imwrite(v, '../img/toy-recover.jpg');
