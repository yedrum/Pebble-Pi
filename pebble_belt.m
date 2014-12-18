%% Prepare USB webcameras

% clear cams
% delete(topcam)
% delete(sidecam)

vid = webcamlist;

topcam = webcam('Logitech HD Pro Webcam C920');
set(topcam, 'ExposureMode', 'auto');

axes(handles.toppreview)
% preview(topcam)
topimg = snapshot(topcam);
ti = imshow(topimg);
% pause(2)
% delete(ti)

axes(handles.sidepreview)
sidecam = webcam('Logitech HD Webcam C270');
set(sidecam, 'ExposureMode', 'auto')
sideimg = snapshot(sidecam);


%% Open Com port with Arduino and configure servo motor

delete(instrfind({'Port'},{'COM4'}))

if exist('a','var') && isa(a,'arduino') && isvalid(a),
%     nothing to do
else
    a=arduino('COM4');
end

% attach servo on pin #7
servoAttach(a,7);
servoStatus(a,7);
val=servoRead(a,7);

% sweep
pos = 75;
servoWrite(a,7,pos);
pause(.5)

servoWrite(a,7,115);
pause(.5)

pos = 96;
servoWrite(a,7,pos);
% rotates servo on pin #9 to 100 degrees
pause(.5)

set(topcam, 'ExposureMode', 'manual');
set(sidecam, 'ExposureMode', 'manual');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Process loop%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axes(handles.topcam)
% cla

accepted = 0;
reject = 0;

i=1;
while i == 1;
    
    axes(handles.sidepreview)
    sideimg = snapshot(sidecam) ;
    si = imshow(sideimg);
    
    axes(handles.toppreview)
    topimg = snapshot(topcam) ;
    ti = imshow(topimg);
    sidergb = sideimg;
    [handles] = pebbles_belt_sideengine(sidergb, handles) ; % side camera analysis
    
%    delete(sideimg)
    %%
    
if (handles.boxside < 600) && (handles.thick < 440) ; % screen size 640 * 480
        
if (handles.tracking > 100)  ;
     tic 
     
           axes(handles.topdone)
            cla
            topimg = snapshot(topcam);
            
            axes(handles.toppreview)
            cla
            imshow(topimg)
           
            [handles] = pebbles_belt_topengine(handles, topimg); % analyse top cam based on side cam.

            % Calibrating from pixels to mm. 
            
            mmx = handles.Iboxwidth/4.8;
            set(handles.x, 'string', mmx);
            
            if mmx < 50;
                mmX = 1;
            else 
                mmX = 0;
            end
            
            mmy = handles.Iboxheight/4.8;
            set(handles.y, 'string', mmy);
            
            if mmy < 50;
                mmY = 1;
            else 
                mmY = 0;
            end
            
            mmz = handles.thick/8; 
            
            if mmy > 40 && mmz < 15;
                mmz = mmz - 1;
            end 
            
            set(handles.z, 'string', mmz);
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%% Sorting Commands and criteria%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
           if mmz > 12 && mmz < 23 && mmx < 70 && mmy < 70 && mmx > 30 && mmy > 30;
               mmZ = 1;
           else
               mmZ = 0;
           end
           %%
           
           if mmZ == 1 && (mmY || mmX == 1);
               
               display('accept')
               pos = 110;
               set(handles.quality, 'string', 'Accept')
  
               
   
           else
               display('deny')
               pos = 70;
               set(handles.quality, 'string', 'deny')
 
               
           end
          
          toptime = toc ;
%% Categorising results

pause(1)

delay = 2; % time to delay before moving servo

% servoWrite(a,7,pos);
pause(.05)

% axes(handles.topdone) 
% clear axis
% axes(handles.sidepreview)
% clear axis

t = timer('TimerFcn', {@pebbles_servocontrol, pos, a}, 'StartDelay', delay);
start(t)

end
        
end
    

% set(handles.time, 'string', elapsedtime);
    
       
% drawnow
%     br = get(handles.br,'Value')
%     if br == 1;
%         break
%     end
%     
%     paws = get(handles.paws, 'Value')
%     if paws == 1;
%         pause
%         display('Hit the Any key (really hard) to resume.')
%     end
    
end

%% Close components. Never gets to this stage. 

delete(topcam)
delete(sidecam)
delete(a)  % end arduino session

clear all
