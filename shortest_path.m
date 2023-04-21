
function [nav_row,nav_col,p_struct]=shortest_path(mat,id,start_point_row,start_point_col,parking_struct)
p_struct=[];
parking_taken=0;
exist=false;
for j=1:length(parking_struct)
    if parking_struct(j).car_id==id
        exist=true;
    end 
end 

if ~exist

shortest_distance=inf;
    [r,c]=size(mat);
        start_row=start_point_row;
        start_col=start_point_col;

        for g=1:length(parking_struct)
           
     if parking_struct(g).status=="free" && parking_struct(g).car_id==-1
      des_row=parking_struct(g).parking_row;
      des_col=parking_struct(g).parking_col;

      bw1=false(r,c);

      bw2=false(r,c);

      bw1(start_row, start_col)=true;
      bw2(des_row, des_col)=true;
              
                      D1 = bwdistgeodesic(mat, bw1, 'cityblock');
                      D2 = bwdistgeodesic(mat, bw2, 'cityblock');
                      D = D1 + D2;
                      D = round(D * 32) / 32;

                      D(isnan(D)) = inf;
                      
                    paths = imregionalmin(D);
                    paths_thinned_many = bwmorph(paths, 'thin', inf);
                   %[nav_row,nav_col]=find(paths_thinned_many==1);
                    dis=D(paths);
                    distance=dis(1);
                    if distance<shortest_distance
                        
                       shortest_distance=distance;
%                         [rows,cols]=find(paths_thinned_many==1);
                        parking_taken=g;
               
                    end
     
         end    
        

        end
 

if parking_taken~=0
parking_struct(parking_taken).status="taken";
parking_struct(parking_taken).car_id=id;
nav_row=parking_struct(parking_taken).parking_row;
nav_col=parking_struct(parking_taken).parking_col;
p_struct=parking_struct;
else
    p_struct=parking_struct;
    nav_row=-1;
    nav_col=-1;
end



else 
    p_struct=parking_struct;
    nav_row=-1;
    nav_col=-1; 


end
end