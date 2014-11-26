function [H] = calculate_homography(corr_1, corr_2)
   A = zeros(size(corr_1,1)*2, 9);

    for i = 1:2:size(corr_1,1);
        %first set of equations
        A(i, 1) = corr_2(i, 1);
        A(i, 2) = corr_2(i, 2);
        A(i, 3) = 1;
        A(i, 4) = 0;
        A(i, 5) = 0;
        A(i, 6) = 0;
        A(i, 7) = -corr_1(i, 1) * corr_2(i, 1);
        A(i, 8) = -corr_1(i, 1) * corr_2(i, 2);
        A(i, 9) = -corr_1(i, 1);

        %second set of equations
        A(i+1, 1) = 0;
        A(i+1, 2) = 0;
        A(i+1, 3) = 0;
        A(i+1, 4) = corr_2(i, 1);
        A(i+1, 5) = corr_2(i, 2);
        A(i+1, 6) = 1;
        A(i+1, 7) = -corr_1(i, 2) * corr_2(i, 1);
        A(i+1, 8) = -corr_1(i, 2) * corr_2(i, 2);
        A(i+1, 9) = -corr_1(i, 2);
    end

    [~, ~, V] = svd(A);
    H = reshape(V(:, end), [3, 3]);
    
    T1 = eye(3);
    T2 = eye(3);
    
    H = (T1\H) * T2;
end