function shifted = im_align(a, b, max_shift, shift_pts)
    [width, height] = size(a);

    rangei = [int8(linspace(-width*max_shift, -1, shift_pts)) 0 int8(linspace(1, width*max_shift, shift_pts))];
    rangej = [int8(linspace(-height*max_shift, -1, shift_pts)) 0 int8(linspace(1, height*max_shift, shift_pts))];
    
    min = ssd(a, b, max_shift);
    mini = 0;
    minj = 0;

    for i = rangei
        for j = rangej
            temp = ssd(a, circshift(b, [i j]), max_shift);
            if temp < min
                min = temp;
                mini = i;
                minj = j;
            end;
        end;
    end;
    
    shifted = circshift(b, [mini minj]);
end
