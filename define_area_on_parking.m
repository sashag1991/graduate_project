function [coord] = define_area_on_parking(area_type)

switch area_type
    case "road"
    disp("Mark top left point and right down point of each blook");
    Area_object = drawrectangle('Color','blue'); 
    num_of_parking=0;
    case "avaliable_parking"
    disp("Mark top left point and right down point of each blook- mark each line diffrently");
    Area_object = drawrectangle('Color','green');
    num_of_parking=input("Enter number of parking lots in each line: \?");
    case "Obstacle"
    disp("Mark top left point and right down point of each blook");
    Area_object = drawrectangle('Color','red');
    num_of_parking=0;
    case "finish"
        disp("Done defining parking lot")
        num_of_parking=0;
        Area_object=[0,0,0,0,num_of_parking];
end
coord=[Area_object.Position,num_of_parking];
end


