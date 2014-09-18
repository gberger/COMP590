im = rgb2gray(imread('../img/toygc.png'));

[imh, imw, nb] = size(im); 
total_px = imh*imw;

im2var = zeros(imh, imw); 
im2var(1:total_px) = 1:total_px; 

A = sparse(total_px, total_px);

for i 
    