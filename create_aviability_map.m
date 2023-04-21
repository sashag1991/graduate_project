function [map]=create_aviability_map(parking_cars)

      PARKING1=[0,0,955,200];
      Number_of_Parkings_1=15;
      Number_of_Parkings_2=10;
      PARKING2=[0,380,660,178];
      
      if py>PARKING1(2) && py<(PARKING1(4)+PARKING1(2))
          
            result=round(px/((PARKING1(3)-PARKING1(1))/Number_of_Parkings_1));




      elseif py>PARKING2(2) && py<(PARKING2(4)+PARKING2(2))

          result=round(px/((PARKING2(3)-PARKING2(1))/Number_of_Parkings_2));

     

      else
          result=-1;

          
      end
          
         
end