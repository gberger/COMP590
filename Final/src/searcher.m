function [ ranking ] = searcher( im_features, dataset_features )
%SEARCHER 
% takes a features vector from an image
%  and the features matrix for the dataset
% returns a sorted N x 2 matrix, with the first row being
%  the distance, and the second row being the index of the datum

    [n, tmp] = size(dataset_features);

    ranking = zeros(n, 2);
    
    for i = 1:n
       d = comparator(im_features, dataset_features(i, :)');
       ranking(i, 1) = d;
       ranking(i, 2) = i;
    end
    
    ranking = sortrows(ranking, 1);
end

