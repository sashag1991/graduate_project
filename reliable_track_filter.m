function [updated_cars,id_nums] = reliable_track_filter(cars)
updated_cars=cars;
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


len=size(updated_cars,2);
Delete_index_vector=[];
id_nums=[];
if len>0
for i=1:len
    
    if updated_cars(i).totalVisibleCount/updated_cars(i).age > 0.5 && updated_cars(i).consecutiveInvisibleCount < updated_cars(i).age*0.15
        Delete_index_vector=[Delete_index_vector i];
        id_nums=[id_nums updated_cars(i).id];
        
    end
    
end
end
updated_cars=updated_cars(Delete_index_vector);
end

