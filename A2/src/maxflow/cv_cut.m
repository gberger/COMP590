function [ Phi ] = cv_cut( f, lambda)
% Chan-Vese Active Contours Segmentation using Graph Cuts
% Input: Original grayscale image f
%        Fidelity parameter lambda (Try 0.1)
% Output: Level Set Function Phi
% Requires Yuri Boykov's maxflow library.

f = double(f);
[m,n]=size(f);

%Parameters
lambda_in = lambda;
lambda_out = lambda;
maxIterations = 10;
%Initial gray values are important.  Change based on image f.
c_in = 50;
c_out = 150;

%Vectorize image f.
f_x = reshape(f,[m*n,1]);

%Use maxflow library to build adjacency matrix A.
%Note this only needs to be done one time.
E = edges4connected(m,n);
V = ones(size(E(:,1)));
A = sparse(E(:,1),E(:,2),V,m*n,m*n,4*m*n);

for iter=1:maxIterations
    T=sparse(m*n,2);
    T(:,1) = lambda_in*(f_x-c_in).^2;
    T(:,2) = lambda_out*(f_x-c_out).^2;

    [flow,labels]=maxflow(A,T);
    Phi = reshape(labels,[m,n]);
    Phi = double(Phi);

    c_out = sum(sum(Phi.*f))/(sum(sum(Phi))+0.01);
    c_in = sum(sum((1-Phi).*f))/(sum(sum(1-Phi))+0.01);

    imagesc(f); colormap gray; 
    hold on; contour(Phi,[0.5,0.5],'r'); hold off;
    drawnow;
end;
end
