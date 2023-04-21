function [new_cars,next_id] = exclude_overlap(cars)
      new_cars=cars;
      distance_matrix_size=size(cars,1);
    
         distance_matrix=zeros(distance_matrix_size);
         
         next_id=0;
         
         if distance_matrix_size>0

         A_index_vector=zeros(1,distance_matrix_size);
         count=1;

             for i=1:distance_matrix_size

                 for j=i:distance_matrix_size
                     
                     bbox_of_car_i=cars(i).bbox;
                     bbox_of_car_j=cars(j).bbox;
                     
                     vec1=[bbox_of_car_i(1)+bbox_of_car_i(3)/2,bbox_of_car_i(2)+bbox_of_car_i(4)/2];
                     vec2=[bbox_of_car_j(1)+bbox_of_car_j(3)/2,bbox_of_car_j(2)+bbox_of_car_j(4)/2];
                     distance_matrix(i,j)=sqrt(sum((vec1-vec2).^2,2));
                     if j>i && distance_matrix(i,j)<30
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