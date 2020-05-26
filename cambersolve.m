function [x_cam, y_cam, max_thicc, max_thicc_position] = cambersolve(xs, ys)

    [~,le_index] = min(abs(xs)); % Gets le index

     ys_upper = ys(1:le_index);
     xs_upper = xs(1:le_index);
     ys_lower = ys(le_index +1:end);
     xs_lower = xs(le_index +1:end);

     nc = 300;
     x_hold = linspace(0,1,nc);

     x_cam = zeros(1,nc);
     y_cam = zeros(1,nc);
     y_thicc = zeros(1,nc);
     
     for i = 1:nc
         [~,upper_index] = min(abs(xs_upper-x_hold(i)));
         [~,lower_index] = min(abs(xs_lower-x_hold(i)));

         y_cam(i) = (ys_upper(upper_index) + ys_lower(lower_index)) / 2;
         x_cam(i) = (xs_upper(upper_index) + xs_lower(lower_index)) / 2;
         y_thicc(i) = ys_upper(upper_index) - ys_lower(lower_index);
     end
     

     [max_thicc,thicc_index] = max(y_thicc);
     max_thicc = max_thicc*100
     max_thicc_position = x_cam(thicc_index);