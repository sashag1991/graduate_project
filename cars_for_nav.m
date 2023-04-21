  function [cars_row,cars_col]=cars_for_nav(road_array,car_center)
        [r,~]=size(car_center);
     for i=1:r
         row_center=cast(car_center(i,2)+car_center(i,4)/2,'int32');
         col_center=cast(car_center(i,1)+car_center(i,3)/2,'int32');
            for k=1:length(road_array)
                min_row=cast(road_array{k}(2),'int32');
                max_row=cast(road_array{k}(2)+road_array{k}(4),'int32');
                min_col=cast(road_array{k}(1),'int32');
                max_col=cast(road_array{k}(2)+road_array{k}(3),'int32');
                if ((row_center>min_row) && (row_center<max_row)) && ((col_center>min_col) && (col_center<max_col)) 
                
                    if (max_row-min_row) >= (max_col-min_col)
                        col=cast((max_col-min_col)/2,'int32');
                        cars_row=[cars_row,row_cente];
                        cars_col=[cars_col,min_col+col];
                 
                    end
                    
                    if (max_row-min_row) < (max_col-min_col)
                        row=cast((max_row-min_row)/2,'int32');
                        cars_row=[cars_row,min_row+row];
                        cars_col=[cars_col,col_center];
                    end
 
                end
            end
     end   
    end
