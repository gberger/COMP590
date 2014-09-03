function cropped = crop_center(img, percent)
	[w, h] = size(img);
	ew = floor(percent * w);
    eh = floor(percent * h);
    cropped = img(ew:w-ew, eh:h-eh);
end