function [P,inliers1,inliers2] = ransacfunc(points1,points2,maxsample,distance,iterations)
%UNTITLED Summary of this function goes here
N=iterations;
[n,~]=size(points1);

inliers1=zeros(n-2,2);
inliers2=zeros(n-2,2);
count=0;
count_temp=0.9;
P=zeros(3,3);
while N>0
    s1=int8(rand*n);
    s2=int8(rand*n);
    while s2==s1
       s2=int8(rand*n); 
    end
    
    while s1==0
       s1=int8(rand*n);  
    end
    
    while s2==0
       s2=int8(rand*n);  
    end
    new_p1=[points1(s1,:);points1(s2,:)];
    new_p2=[points2(s1,:);points2(s2,:)];
    A=zeros(maxsample*2,9);
    for i=1:maxsample
        A(i*2-1,:)=[new_p1(i,:),1,0,0,0,new_p1(i,:).*(-new_p2(i,1)),-new_p2(i,1)]; 
        A(i*2,:)=[0,0,0,new_p1(i,:),1,new_p1(i,:).*(-new_p2(i,2)),-new_p2(i,2)];
    end

[~,~,R] = svd(A);
p = R(:,end);

p = p/p(end);
P = reshape(p,3,3)';


temp_p1=points1;
temp_p2=points2;

if s1>s2
    temp_p1(s2,:)=[];
    temp_p2(s2,:)=[];
    temp_p1(s1-1,:)=[];
    temp_p2(s1-1,:)=[];   

else
    temp_p1(s1,:)=[];
    temp_p2(s1,:)=[];
    temp_p1(s2-1,:)=[];
    temp_p2(s2-1,:)=[];  
end



temp_p2=temp_p2.';
result=P*([transpose(temp_p1);ones(1,n-2)]);
for i=1:length(result)
    result(1,i)=result(1,i)/result(3,i);
    result(2,i)=result(2,i)/result(3,i);
    result(3,i)=1;
end

in=zeros(1,n-2); 
for i=1:n-2
   
    
     dis=(((result(1,i)-temp_p2(1,i))^2)+((result(2,i)-temp_p2(2,i))^2))^0.5;

   if dis<distance
       count=count+1;
       in(count)=i;
   end
end


temp_p2=temp_p2.';
in=in(1:count)

if count_temp<(count/n)
       inliers1=[temp_p1(in,1);temp_p1(in,2)];
  
       inliers2=[temp_p2(in,1);temp_p2(in,2)];
       
       count_temp=count/n;
end

N=N-1;
count=0;
end

end



