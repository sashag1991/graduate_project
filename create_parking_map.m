function  create_parking_map(cellarray,parking,color,axes1)

if parking==true
  for i=1:length(cellarray)
      cellarray{i}(3)=(cellarray{i}(3)/cellarray{i}(5));
     rectangle('Parent',axes1,'Position',cellarray{i}(1:4),'EdgeColor',color); 
      for k=1:cellarray{i}(5)-1
       cellarray{i}(1)=cellarray{i}(1)+cellarray{i}(3);
       cellarray{i};
       rectangle('Parent',axes1,'Position',cellarray{i}(1:4),'EdgeColor',color); 
      end
end
else
    for i=1:length(cellarray)
      rectangle('Parent',axes1,'Position',cellarray{i}(1:4),'EdgeColor',color); 
    end

end

