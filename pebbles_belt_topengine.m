function [handles] = pebbles_belt_topengine1(handles, topimg, a);

topimg = uint8(topimg); % need to be careful pebble isn't touching fame edge or there will be an error here.
% WHY?
hsvim1 = rgb2hsv(topimg);

% Extract out the H, S, and V images individually

%% hue image
  
  axes(handles.tophisto);
  cla
  hImage = hsvim1(:,:,1);
  imshow(hImage);
    
%% hue histogram
%     axes(handles.tophisto);
% 	[hueCounts, hueBinValues] = imhist(hImage); 
% 	maxHueBinValue = find(hueCounts > 0, 1, 'last'); 
% 	maxCountHue = max(hueCounts); 
% 	bar(hueBinValues, hueCounts, 'r'); 
% 	grid on; 
% 	xlabel('Hue Value'); 
% 	ylabel('Pixel Count'); 
% 	
hueThresholdLow = 0;
hueThresholdHigh = 0.89; % changed from .88 to try and minimise light scatter interference

hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);

pebbleMask = imclearborder(hueMask);

% Smooth the border using a morphological closing operation, imclose().
structuringElement = strel('disk', 8);
pebbleMask = imclose(pebbleMask, structuringElement);
% convert to binary	
pebbleMask = uint8(bwareaopen(pebbleMask, 5000));
% fill holes in image
pebbleMask = uint8(imfill(pebbleMask, 'holes'));

%%
statst = regionprops(pebbleMask, 'BoundingBox'); %call regionproperties of object. 

box = [statst.BoundingBox] ; % [ulcorner, width] 
% Minaxis = [statst.MinorAxisLength] ; %Axis length from ellipsoid comparison. 
% Majoraxis = [statst.MajorAxisLength] ;

TF = isempty(box); % returns 1 if empty 

if TF < 1;
    check0=0
handles.Iboxwidth = box(1,3); %x width

handles.Iboxheight = box(1,4); %y width

handles.tracking = box(1,1);

%% post analysis - this whole region could be what's slow. 

% mask out background
pMask = cast(pebbleMask, class(topimg));

maskedImage = pMask .* topimg(:,:,1);

maskS = pMask.* topimg(:,:,2);

maskV =  pMask .* topimg(:,:,3);

% Concatenate the masked color bands to form the rgb image.
maskedRGB = cat(3, maskedImage, maskS, maskV);


 %% colour processing

axes(handles.topdone)
cla
rgbcrop = imcrop(maskedRGB, statst.BoundingBox);
imshow(rgbcrop);

if (handles.Iboxwidth < 600) && (handles.Iboxheight < 440) ; % screen size 640 * 480
check1 = 1
if (handles.tracking < 400 && handles.tracking > 100)  ; 
    
            check2=2
            
            mmx = handles.Iboxwidth/4.8
            set(handles.x, 'string', mmx);
            
            if mmx < 50;
                mmX = 1;
            else 
                mmX = 0;
            end
            
            mmy = handles.Iboxheight/4.8
            set(handles.y, 'string', mmy);
            
            if mmy < 50;
                mmY = 1;
            else 
                mmY = 0;
            end

   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%% Sorting Commands and criteria%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
           if mmx < 70 && mmy < 70 && mmx > 30 && mmy > 30 ;
               mmZ = 1;
           else
               mmZ = 0;
           end
           %%
           
           if mmZ == 1 && (mmY || mmX == 1);
               
               display('accept')
               pos = 120;
               set(handles.quality, 'string', 'Accept')
   
           else
               display('deny')
               pos = 70;
               set(handles.quality, 'string', 'deny')
              
               
           end
          
          toptime = toc ;
          
%% Categorising results
 %% it's new
%  axes(handles.sidepreview)
%  
%  si = imshow(sideimg) ;
%  
%  [handles] = pebbles_belt_sideengine1(handles, sideimg);

    
pause(1)

delay = 2; % time to delay before moving servo


t = timer('TimerFcn', {@pebbles_servocontrol, pos, a}, 'StartDelay', delay);
start(t)

clear ti
clear topimg
end
end

% end

pMask = [];
maskedImage = [];
maskS = [];
maskV = [];
topimg = [];
end 
