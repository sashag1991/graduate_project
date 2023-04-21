classdef track_calculation < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Detector
        BlobAnalyser
        nextId
        cars_tracking_array
        r
        
   end
    
    methods
        function obj = track_calculation(d,b,n)
            %UNTITLED7 Construct an instance of this class
            %   Detailed explanation goes here
            if nargin==3
            obj.Detector=d;
            obj.BlobAnalyser=b;
            obj.nextId=n;
            obj.cars_tracking_array=initializeTracks();
            end

        end
        function [new_track_array]=cam1_calc(obj,f)
          
            %UNTITLED7 Construct an instance of this class
            %   Detailed explanation goes here
            [centroids,b_boxes,~]=detectObjects(f,obj.Detector,obj.BlobAnalyser);
            obj.nextId
            [next,new_track_array]=detection_analysis(obj.cars_tracking_array,centroids,b_boxes,obj.nextId);
            obj.nextId=next;
            obj.cars_tracking_array=new_track_array;
           
        end
        
        function [new_track_array]=one_transform_calc(obj,f,transform_matrix)
            %UNTITLED7 Construct an instance of this class
            %   Detailed explanation goes here
 
            [centroids,b_boxes,~]=detectObjects(f,obj.Detector,obj.BlobAnalyser);            
            
            if ~isempty(centroids)
            [n2,~]=size(centroids);
             x_tag_2=[transpose(centroids);ones(1,n2)];
             centroids=transpose((transform_matrix)\x_tag_2);
             centroids=centroids(:,1:end-1);

            end 
    
            if ~isempty(b_boxes)
            [b2,~]=size(b_boxes);
             temp=transpose(b_boxes);
             b_box_tag_2=[temp(1:2,:);ones(1,b2)];
             temp2=single(b_box_tag_2);
             b_boxes_temp_1=inv(transform_matrix)*temp2;
             b_boxes_temp_2=transpose(b_boxes_temp_1);
             b_boxes=[b_boxes_temp_2(:,1:end-1),b_boxes(:,3:4)];

            end 

            [next,new_track_array]=detection_analysis(obj.cars_tracking_array,centroids,b_boxes,obj.nextId);

            obj.nextId=next;
            obj.cars_tracking_array=new_track_array;
           
        end
        
        
        function [next,new_track_array]=two_transforms_calc(obj,f,transform_matrix1,transform_matrix2,n)
            %UNTITLED7 Construct an instance of this class
            %   Detailed explanation goes here
            obj.nextId=n;
            [centroids,b_boxes,~]=detectObjects(f,obj.Detector,obj.BlobAnalyser);  
            
            
             if ~isempty(centroids)
            [n,~]=size(centroids);
             x_tag_4=[transpose(centroids);ones(1,n)];
             temp_1=inv(transform_matrix1)*(x_tag_4);
             temp_2=inv(transform_matrix2)*(temp_1);
             temp_3=transpose(temp_2);
             centroids=temp_3(:,1:end-1);

                       end 
     
              if ~isempty(b_boxes)
             [b,~]=size(b_boxes);
             temp=transpose(b_boxes);
             b_box_tag_4=[temp(1:2,:);ones(1,b)];
             temp2=single(b_box_tag_4);
             b_boxes_temp_1=inv(transform_matrix1)*temp2;
             b_boxes_temp_2=inv(transform_matrix2)*b_boxes_temp_1;
             b_boxes_temp_2=transpose(b_boxes_temp_2);
             b_boxes=[b_boxes_temp_2(:,1:end-1),b_boxes(:,3:4)];

                end 

            [next,new_track_array]=detection_analysis(obj.cars_tracking_array,centroids,b_boxes,obj.nextId);

            obj.nextId=next;
            obj.cars_tracking_array=new_track_array;
           
        end
        

    end
end

