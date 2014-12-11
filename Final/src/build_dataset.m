function [ dataset_names, dataset_features ] = build_dataset(directory, filename)
    list = dir(strcat(directory, '/*.jpg'));

    [n, tmp] = size(list);

    MASKS = 5;
    h_bins = 8;
    s_bins = 12;
    v_bins = 3;
    FEATURES = MASKS*h_bins*s_bins*v_bins;

    dataset_names = repmat({'--'}, n, 1);
    dataset_features = zeros(n, FEATURES);
    
    i = 1;
    for file = list'
        dataset_names{i} = file.name;
        im = imread(strcat('../img/', file.name));
       
        [h, w, colors] = size(im);
        
        if h > w
           imr = imresize(im, [300 NaN]);
        else
           imr = imresize(im, [NaN 300]);
        end
        
        features = descriptor(imr, h_bins, s_bins, v_bins);
        
        dataset_features(i,:) = features;

        i = i+1;
    end

    save(filename, 'dataset_names', 'dataset_features');
end
