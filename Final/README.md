# Final Project - Reverse Image Search

## Overview

In this assignment I will explore reverse image searching.

There are two possible ways to do image searching: either via metadata (such as user-provided tags and text, timestamp or geolocation) or via the image's content.

When searching via metadata, textual or numeric output is often enough. But when searching for an image's content, the best way to represent that is with another image.

There are many uses to reverse image search:

* trace an image's origin on the internet
* find higher resolution versions of an image at hand
* obtain metadata, including possibly a description of the image (if the images in the dataset themselves have metadata)

The dataset used is the [INRIA Holidays dataset](http://lear.inrialpes.fr/people/jegou/data.php), containing 1500 images.


## Image Descriptor

How do we search for similar images when each image consists of millions of pixels?

One way to do it is reduce an image to a smaller number of numeric characteristics called **features**, extract by using **descriptor functions**.

Depending on the desired results, there are many descriptors that can be used:

* moments can be used to characterize shape
* gradients can be used to characterize shape and texture
* color histograms can be used to characterize color distribution

For this project, we will use color histograms. They better represent the similarities and differences between scenes commonly photographed during holidays.

Specifically, we will use 3D histograms in HSV space. This means that if we want `h` hue bins, `s` saturation bins, and `v` value bins, we will have a `h x s x v` 3D matrix, where the element `(i,j,k)` represents the chance that a pixel from the image lands in the `i`th hue bin AND in the `j`th saturation bin AND in the `k`th value bin.

Furthermore, we will build region-based histograms, instead of global histograms. The 5 regions are defined as:

* ellipse centered in the center of the image, with radii equal to 75% of the image's dimensions
* the four quadrants of the images, except for the areas of the ellipse

![](regions.png)

Of course, we also normalize the histograms by region, so that the values lie between 0 and 1.

This results in a `5 * h * s * v`-dimensional feature vector.

The code for this is available in `src/descriptor.m`.

## Building the Dataset

Once we know how to describe an image, we can build a dataset of described images from our dataset of actual images. Describing an image takes relatively long time, so prebuilding this dataset is very beneficial to the performance of the actual search.

Because the histograms are normalized, we can actually use reduced versions of the images as input to the descriptor function. This results in a 0.1% error when compared to describing the full size image, but represents speedups of two orders of magnitude, so it's a good tradeoff.

We save the described dataset in a MAT-file, to be loaded into Matlab later. A dataset has been prebuilt and is available in `dataset/dataset.mat`. It uses 8 H-bins, 12 S-bins and 3 V-bins.

The code for this is available in `src/searcher.m`.

## Searching the Dataset

With the comparator function and the described dataset available, it is very simple to compare the features of an arbitrary image to the dataset, and find the most similar images.

Similarity between two feature vectors can be measured in many ways. I chose to use the chi-squared distance measure. CSD is generally used to compare discrete probability distributions, which is what color histograms are. The CSD between two vectors `u` and `v` is defined as:

![](csd.png)

A CSD of 0 means two images are identical. The higher the CSD gets, the more different the images are.

Our search of the dataset will consist of simply sorting the images in the dataset by CSD to the given query image. 

A possible improvement over this is using a K-Max algorithm, which allows us to more efficiently query for the top 10 images, for example. Naïve searching and sorting over N images has time complexity of `O(N lg N)`, while getting only the top K has time complexity of `O(N lg K)`. 

Other approaches to this include using other algorithms, such as tree or graph algorithms, or clustering.

## Results

### Example 1

#### Query

![](results/1-1.jpg)

#### Results

![](results/1-2.jpg)

![](results/1-3.jpg)

![](results/1-4.jpg)

![](results/1-5.jpg)


### Example 2

#### Query

![](results/2-1.jpg)

#### Results

![](results/2-2.jpg)

![](results/2-3.jpg)

![](results/2-4.jpg)

![](results/2-5.jpg)


### Example 3

#### Query

![](results/3-1.jpg)

#### Results

![](results/3-2.jpg)

![](results/3-3.jpg)

![](results/3-4.jpg)

![](results/3-5.jpg)


### Example 4

#### Query

![](results/4-1.jpg)

#### Results

![](results/4-2.jpg)

![](results/4-3.jpg)

![](results/4-4.jpg)

![](results/4-5.jpg)


### Example 5

#### Query

![](results/5-1.jpg)

#### Results

![](results/5-2.jpg)

![](results/5-3.jpg)

![](results/5-4.jpg)

![](results/5-5.jpg)


### Example 6

#### Query

![](results/6-1.jpg)

#### Results

![](results/6-2.jpg)

![](results/6-3.jpg)

![](results/6-4.jpg)

![](results/6-5.jpg)
