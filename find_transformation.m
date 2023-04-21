function [T] = find_transformation(points1,points2,distance,num)
%UNTITLED Summary of this function goes here
[n,~]=size(points1);
k=n;
count=0;
count_temp=0.1;

A=zeros(8,9);
while num>1
    s1=int8(rand*k);
    s2=int8(rand*k);
    s3=int8(rand*k);
    s4=int8(rand*k);
    
    while s2==s1 || s2==s3 || s1==s3 || s1==0 || s2==0 || s3==0 || s4==0 || s4==s1 || s4==s3 || s4==s2
        s1=int8(rand*k);
        s2=int8(rand*k);
        s3=int8(rand*k);
        s4=int8(rand*k);
    end

    new_p1=[points1(s1,:);points1(s2,:);points1(s3,:);points1(s4,:)];
    new_p2=[points2(s1,:);points2(s2,:);points2(s3,:);points1(s4,:)];
    A(9,:)=[0,0,0,0,0,0,0,0,1];
    for i=1:4
        A(i*2-1,:)=[new_p1(i,:),1,0,0,0,new_p1(i,:).*(-new_p2(i,1)),-new_p2(i,1)]; 
        A(i*2,:)=[0,0,0,new_p1(i,:),1,new_p1(i,:).*(-new_p2(i,2)),-new_p2(i,2)];
    end

[~,~,R] = svd(A);
p = R(:,end);
p = p/p(end);
P = reshape(p,3,3)';


temp_p1=points1;
temp_p2=points2;

B=sort([s1,s2,s3,s4]);
s1=B(1);
s2=B(2);
s3=B(3);
s4=B(4);
temp_p1(s1,:)=[];
temp_p1(s2-1,:)=[];
temp_p1(s3-2,:)=[];
temp_p1(s4-3,:)=[];
temp_p2(s1,:)=[];
temp_p2(s2-1,:)=[];
temp_p2(s3-2,:)=[];
temp_p2(s4-3,:)=[];


temp_p2=temp_p2.';
temp_p1=[temp_p1.';ones(1,k-4)];
result=P*temp_p1;
for i=1:k-4
    result(1,i)=result(1,i)/result(3,i);
    result(2,i)=result(2,i)/result(3,i);
    result(3,i)=1;
end

for i=1:k-4
   
    
%      dis=(((result(1,i)-temp_p2(1,i))^2)+((result(2,i)-temp_p2(2,i))^2))^0.5;
dis=norm(abs(result(:,i)-[temp_p2(:,i);1]));


   if dis<distance
       count=count+1;

   end
end

if count_temp<(count/k)
  
       count_temp=count/k;
       T=P;
end

num=num-1;
count=0;
end

end
