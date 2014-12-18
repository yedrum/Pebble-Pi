
function [handles]=pebbles_prototype_sideengine1(handles, sidergb);

axes(handles.sidepreview)

imshow(sidergb);

colours = 5; % play with different configurations

[sideind, map] = rgb2ind(sidergb, colours, 'nodither') ; %convert rgb to indexed image.

for i=1:colours ;
    
if map(i,1)>.55 && map(i,2)<.67 && map(i,2)>.1 && map(i,3)<.7 ; 
    
    map(i,:) = [0,0,0] ; %if it's red then turn it black. 
    
else
    
 map(i,:) = [1,1,1] ; %if it's not red then turn it white.
 
end
end


%% Image Pre-processing

% axes(handles.sidetrack) ;
% cla
sidebw=ind2gray(sideind, map) ; %convert to grayscale - needed to correctly define object. 
imshow(sidebw); %draw binary object. 

pebbleMask = uint8(bwareaopen(sidebw, 5000)) ; % sweep to clear small objects

statss = regionprops(pebbleMask, 'BoundingBox', 'Centroid') ; %call regionproperties of object. 

box = [statss.BoundingBox] ; % [ulcorner, width] 

TF = isempty(box); % returns 1 if empty 

if TF < 1; % only process if there's a box to process. 
    
handles.boxside = box(1,3); %x width

% set(handles.x, 'string', Iboxwidth);
handles.thick = box(1,4); %y height

mmz = handles.thick/8; 
set(handles.z, 'string', mmz);

handles.tracking = box(1,1); % x value of upperleft corner of bounding box

% set(handles.centroid, 'string', statss.Centroid); % display centroid location in gui.

axes(handles.sidepreview)

box = reshape(box, [4 1]); %no idea why i need this. but i do.

for cnt=1:1 ;
R = rectangle('position', box(:,cnt),'edgecolor','r'); %draw red box. 
end

elseif TF == 1; % if no object exists then don't try and define one. 
        
        handles.boxside = 640;
        handles.thick = 480;

end
%  delete(sideimg) ;
end
