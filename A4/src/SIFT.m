function [corr_1, corr_2] = SIFT(im1, im2)
    % get descriptors
    [fa, da] = sift_descriptors(im1);
    [fb, db] = sift_descriptors(im2);
    % find matches
    [matches, scores] = vl_ubcmatch(da, db, 1);
    % select better matches
    matches = matches(:, (scores < 4096));
    % select corresponding points
    corr_1 = fa(1:2, matches(1, :))';
    corr_2 = fb(1:2, matches(2, :))';
    % plot lines between the corresponding points
    figure;
    padded = padarray(im2, size(im1,1)-size(im2,1), 'post');
    imshow([im1 padded]);
    hold on;
    for i = 1:size(corr_1)
        plot([corr_1(i, 1) size(padded, 2) - corr_2(i, 1) + size(im1,2)], [corr_1(i, 2) corr_2(i, 2)], 'r');
    end
    hold off;
end

function [f, d] = sift_descriptors(I)
    I = single(rgb2gray(I));
    [f, d] = vl_sift(I);
end


% source: vlfeat.org