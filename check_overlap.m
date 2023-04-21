function [new_cars,next_id] = check_overlap(cars)
      new_cars=cars;
      distance_matrix_size=size(cars,2);
    
         distance_matrix=zeros(distance_matrix_size);
         
         next_id=0;
         
         if distance_matrix_size>0

         A_index_vector=zeros(1,distance_matrix_size);
         count=1;

             for i=1:distance_matrix_size

                 for j=i:distance_matrix_size
                     
                     bbox_of_car_i=cars(i).bbox;
                     bbox_of_car_j=cars(j).bbox;
                     
                     distance_matrix(i,j)= bboxOverlapRatio(bbox_of_car_i,bbox_of_car_j);
                     if j>i && distance_matrix(i,j)>0.15
                         A_index_vector(count)=j;
                         count=count+1;
                     end

                 end
                 
             end
             A_index_vector_2=transpose(nonzeros(unique(A_index_vector)));
             cars(A_index_vector_2)=[];
             new_cars=cars;
             next_id=new_cars(end).id;
              
         end
         
         
         
         
end