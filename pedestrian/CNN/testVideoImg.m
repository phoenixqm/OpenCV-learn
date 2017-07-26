vidObj = VideoReader('airport2.mp4');
vidObj.CurrentTime = 0.5;
currAxes = axes;

% Read video frames until available
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'on';
    pause(1/vidObj.FrameRate/2);
end

% img = readFrame(video);
% imshow(img);