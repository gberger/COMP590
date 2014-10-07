im = im2double(imread('../../img/fish2.jpg'));
[height,width,colors] = size(im);
m = rgb2gray(im);

mask = logical(im2double(imread('../../img/fish2-mask.bmp')));

disp('building graph');
N = height*width;

% construct 4-connected graph
% weight between pixels is square of diff
E = edges4connected(height,width);
V = abs(m(E(:,1))-m(E(:,2))).^2;
A = sparse(E(:,1),E(:,2),V,N,N,4*N);

% construct 8 histogram bins
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
    
    hist_fg(:, c) = hist_fg(:, c)/sum(hist_fg(:, c));
    hist_bg(:, c) = hist_bg(:, c)/sum(hist_bg(:, c));
end

% source-pixel-sink
disp('calculating source-pixel-sink values');
T = sparse(N, 2);
for px = 1:N
    T(px, 1) = 1;
    T(px, 2) = 1;
end

for c = 1:colors
    channel = im(:,:,c);
    for px = 1:N
        T(px, 1) = T(px, 1)* hist_fg(floor(channel(px)*bins) + 1, c);
        T(px, 2) = T(px, 2)* hist_bg(floor(channel(px)*bins) + 1, c);
    end
end

disp('calculating maximum flow');

[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);

imagesc(labels); title('labels');

