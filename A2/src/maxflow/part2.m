im = im2double(imread('../../img/fish2.jpg'));
[height,width,colors] = size(im);

mask = logical(im2double(imread('../../img/fish2-mask.bmp')));

disp('building graph');
N = height*width;

% construct 4-connected graph
% weight between pixels is sum of (square of diff) of each color
E = edges4connected(height,width);

[edges, tmp] = size(E); 
V = zeros(edges, 1);

for c = 1:colors
    channel = im(:,:,c);
    V = V + abs(channel(E(:,1)) - channel(E(:,2))).^2;
end
V = V ./ max(V);

A = sparse(E(:,1),E(:,2),V,N,N,4*N);

% construct histogram bins
disp('building histograms');
bins = 8;
smooth_window_width = 3;
breakpoints = linspace(0, 1, bins+1);

hist_fg = zeros(bins+1, colors);
hist_bg = zeros(bins+1, colors);
for c = 1:colors
    channel = im(:,:,c);
    hist_fg(:, c) = smooth(histc(channel(mask), breakpoints), smooth_window_width);
    hist_bg(:, c) = smooth(histc(channel(~mask), breakpoints), smooth_window_width);
    
    hist_fg(:, c) = hist_fg(:, c) ./ max(hist_fg(:, c));
    hist_bg(:, c) = hist_bg(:, c) ./ max(hist_bg(:, c));
end

% source-pixel-sink
disp('calculating source-pixel-sink values');
T = sparse([ones(1,N); ones(1,N)]');

for c = 1:colors
    channel = im(:,:,c);
    for px = 1:N
        T(px, 1) = T(px, 1)* hist_fg(floor(channel(px)*bins) + 1, c);
        T(px, 2) = T(px, 2)* hist_bg(floor(channel(px)*bins) + 1, c);
    end
end

T(:, 1) = T(:, 1) ./ max(T(:,1));
T(:, 2) = T(:, 2) ./ max(T(:,2));

% view connections to source
%imshow(full(reshape(T(:,1), 140, 140)));
% view connections to sink
%imshow(full(reshape(T(:,1), 140, 140)));

disp('calculating maximum flow');

[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);

% view mask
%imagesc(labels); title('labels');


% *********************************
% POISSON BLENDING - SAME AS PART 1
% *********************************
disp('executing poisson blending');

padding = 150;

mask = ~labels;

dst_full = im2double(imread('../../img/underwater-small.jpg'));

dst = dst_full((padding+1):(padding+height), (padding+1):(padding+width), :);
src = im;

im2var = zeros(height, width); 
im2var(1:N) = 1:N; 

A = speye(N, N);

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
for i = 2:height-1
    for j = 2:width-1
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

res = zeros(height, width, 3);

for c = 1:colors
    grad = conv2(src(:,:,c), laplacian, 'same');
    b = zeros(N, 1);
    for i = 1:width
       for j = 1:height
           px = im2var(i, j);
           if mask(px)
              b(px) = grad(i, j); 
           else
              b(px) = dst(i, j, c);
           end
       end
    end
    x = A\b;
    x = reshape(x, height, width);
    res(:, :, c) = x;
end

finalimg = dst_full;
finalimg((padding+1):(padding+height), (padding+1):(padding+width), :) = res;

imshow(finalimg);
