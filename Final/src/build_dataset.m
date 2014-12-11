function [ dataset_names, dataset_features ] = build_dataset(directory, filename)
    list = dir(strcat(directory, '/*.jpg'));
    n = size(list, 1);

    MASKS = 5;
    h_bins = 8;
    s_bins = 12;
    v_bins = 3;
    FEATURES = MASKS*h_bins*s_bins*v_bins;

    dataset_names = repmat({'--'}, n, 1);
    dataset_features = zeros(n, FEATURES);
    
    i = 1;
    for file = list'
        im = imread(strcat('../img/', file.name));
        imr = resize_constraint(im, 300);
        
        dataset_names{i} = file.name;
        dataset_features(i,:) = descriptor(imr, h_bins, s_bins, v_bins);;

        i = i+1;
    end

    save(filename, 'dataset_names', 'dataset_features');
end

function [ imr ] = resize_constraint(im, cons)
    % resizes an image to be at most cons x cons.
    % maintains aspect ratio

    h = size(im, 1);
    w = size(im, 2);

    % resize image to at most 300x300
    if h > w
       imr = imresize(im, [cons NaN]);
    else
       imr = imresize(im, [NaN cons]);
    end

end