function TT = NEW_RANSAC(p1,p2,num,distance)
[n,~]=size(p1);
k=n;
count=0;
count_temp=0.5;

while num>1

    s1=int8(rand*k);
    s2=int8(rand*k);
        while s2==s1 || s1==0 || s2==0
        s1=int8(rand*k);
        s2=int8(rand*k);
        end
        
temp_p1=p1;
temp_p2=p2;
B=sort([s1,s2]);
s1=B(1);
s2=B(2);
temp_p1(s1,:)=[];
temp_p1(s2-1,:)=[];
temp_p2(s1,:)=[];
temp_p2(s2-1,:)=[];


   [tform,~,~] = estimateGeometricTransform(...
  temp_p1, temp_p2 , 'affine','MaxNumTrials',1000,'MaxDistance',5);
 tform.T=transpose(tform.T);
temp_p2=temp_p2.';
temp_p1=[temp_p1.';ones(1,k-2)];
result= tform.T*temp_p1;
for i=1:k-4
    result(1,i)=result(1,i)/result(3,i);
    result(2,i)=result(2,i)/result(3,i);
    result(3,i)=1;
end


for i=1:k-4

dis=norm(abs(result(:,i)-[temp_p2(:,i);1]));

   if dis<distance
       count=count+1;

   end
end

if count_temp<(count/k)
  
       count_temp=count/k;
       TT=tform.T.';
end



num=num-1;
end


end