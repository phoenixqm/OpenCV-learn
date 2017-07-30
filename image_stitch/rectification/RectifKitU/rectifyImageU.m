function err = rectifyImageU(img_base)
% Rectification without calibration (only correspondences)

% This function reads two images (PNG) and point matches from file.
% It outputs the two rectified images in PNG format.
%
% The bounding box and the transformation that has been applied
% are saved in the PNG metadata

%         Andrea Fusiello, 2007 (andrea.fusiello@univr.it)



% load matches from file
load(['data/' img_base '_pairs'])
% Note: the user who wants to rectify his own images must provide
% the matches in the 2xn arrays ml and ml at this point


% --------------------  PLOT LEFT
%figure(1)
subplot(2,2,1)
[IL] = imread(['images/' img_base '0.png'],'png');
image(IL);
axis image
hold on
title('Left image');
plot(ml(1,:), ml(2,:),'ro','MarkerSize',12);
hold off


% Epipolar geometry
F = fm(ml,mr);
res = sqrt(sum(sampson(F,ml,mr))/(length(ml)-1));
fprintf('Sampson RMS (pre): %0.5g pixel \n',res);


% --------------------  PLOT RIGHT
%figure(2)
subplot(2,2,2)
[IR] = imread(['images/' img_base '1.png'],'png');
image(IR);
axis image
hold on
title('Right image');
plot(mr(1,:), mr(2,:),'ro','MarkerSize',12);
% plot epipolar lines
x1 =0;
x2 = size(IR,2);
for i =1:size(ml,2)
liner = F  * [ml(:,i) ; 1];
    plotseg(liner,x1,x2);
end
hold off


% --------------------  RECTIFICATION

disp('---------------------------------- rectifying...')

width = size(IR,2) ;
height = size(IR,1);

[TL,TR] = compRectif(ml,mr,width,height);

disp('---------------------------------- warping...')

% find the smallest bb containining both images
bb = mcbb(size(IL),size(IR), TL, TR);

for c = 1:3

    % Warp LEFT
    [JL(:,:,c),bbL,alphaL] = imwarp(IL(:,:,c), TL, 'bilinear', bb);

    % Warp RIGHT
    [JR(:,:,c),bbR,alphaR] = imwarp(IR(:,:,c), TR, 'bilinear', bb);

end

% warp left and right points
mlx = p2t(TL,ml);
mrx = p2t(TR,mr);

err = sqrt(sum(sampson(star([1 0 0]),mlx,mrx))/(length(mlx)-1));
fprintf('Sampson RMS (post): %0.5g pixel \n',err);


% --------------------  PLOT LEFT
%figure(3)
subplot(2,2,3)
image(JL);
axis image
hold on
title('Rectified left image');
x2 = size(JL,2);
for i =1:size(mlx,2)
    plot (mlx(1,i)-bbL(1), mlx(2,i)-bbL(2),'w+','MarkerSize',12);
end
hold off


% --------------------  PLOT RIGHT
%figure(4)
subplot(2,2,4)
image(JR);
axis image
hold on
title('Rectified right image')
plot(mrx(1,:)-bbR(1), mrx(2,:)-bbR(2),'w+','MarkerSize',12);
x2 = size(JR,2);
for i =1:size(mlx,2)
    liner = star([1 0 0])  * [mlx(:,i) - bbL(1:2) ;  1];
    plotseg(liner,x1,x2);
end
hold off

% -------------------- SAVE FILES

imwrite(JL,['imagesU/' img_base '_R_0.png'],'png', 'Alpha', uint8(255*alphaL), ...
    'BB', num2str(bbL'), 'Xform', num2str(TL(:)'));

imwrite(JR,['imagesU/' img_base '_R_1.png'],'png', 'Alpha', uint8(255*alphaR), ...
    'BB', num2str(bbR'), 'Xform', num2str(TR(:)'));

disp(['wrote rectified images: ' 'imagesU/' img_base '_R_0.png  ' 'imagesU/' img_base '_R_1.png']);


