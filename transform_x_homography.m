function [tx] = transform_x_homography(points1,points2,distance)
%UNTITLED Summary of this function goes here
[n,~]=size(points1);
count=0;
count_temp=0.9;
while n>0
new_p1=points1(n,:);
new_p2=points2(n,:);
transform=new_p2(1,1)-new_p1(1,1);

temp_p1=points1;
temp_p2=points2;

temp_p1(n,:)=[];
temp_p2(n,:)=[];

result=temp_p1(:,1)+transform;

for i=1:n-1
   
    
     dis=abs(result(i,1)-temp_p2(i,1));

   if dis<distance
       count=count+1;
   end
end


if count_temp<(count/n)

       tx=abs(transform);
       count_temp=count/n;
end

n=n-1;
count=0;
end

end