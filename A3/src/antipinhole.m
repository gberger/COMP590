%% Stereo Pinhole Camera assignment - Antipinhole
% In this part of the assignment, we took pictures with and without a
% circular occluder blocking incoming light reflected off of an outside
% object. Our antipinhole images are at https://drive.google.com/open?id=0B_zRU2Dv83izcVU1NHVIMlJCZDg&authuser=0
function [] = antipinhole(scenePath, antipinholePath)
    scene = im2double(imread(scenePath));
    antipinhole = im2double(imread(antipinholePath));

    scene = imresize(scene,0.125,'bilinear'); % shrink image to remove artifacts 
    scene = max(0,min(1,scene)); % remove imresize errors
    antipinhole = imresize(antipinhole,0.125,'bilinear');
    antipinhole=max(0,min(1,antipinhole));
    % Show the images
    plotN = 2;
    plotM = 2;
    figure(1);
    subplot(plotN, plotM, 1);
    imshow(scene);
    title('Scene image');

    subplot(plotN, plotM, 2);
    imshow(antipinhole);
    title('Antipinhole image');
    % Find the difference image
    subplot(plotN, plotM, 3);
    imagesc(flip(imrotate(real((scene - antipinhole).^.25), 180)));
    colormap jet
    colorbar
    title('difference image');    
end