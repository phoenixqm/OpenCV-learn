Reload_readear_Data = false;
Init_cnn = true;
AfterNMS = true;
ChoosPosNeg = false;
USE_ExtraFeat = false;
CaltechTrain = true; %true: test on the Caltech-test data, trained on the Caltec-Train dataset
INRIA=false;%true: test on the ETH dataset, trained on the INRIA dataset

% clear all;
close all;
if ~exist('Pathadd', 'var')
    addpath ..\util
    addpath ..\tmptoolbox\matlab
    addpath ..\tmptoolbox\classify
    addpath ..\tmptoolbox
    addpath ..\tmptoolbox\images
    addpath ..\dbEval
    Pathadd = 1;
end;
wRatio=1.4;
hRatio=1.4;
Crop = [12+1 12+84; 5 5+28-1];
CropSize = Crop(:,2)-Crop(:,1)+1;


if CaltechTrain
    TrainCropImagepath=['..\data\CaltechTrain\' sprintf('w_%f_h_%f',wRatio,hRatio)];
    dstCropImagepath=['..\data\CaltechTest\' sprintf('w_%f_h_%f',wRatio,hRatio)];
    ReaderDataFName = [dstCropImagepath '\CNNDLTData3Color63_4.mat'];
    load('..\model\CaltechTrain\CNN_CDBN_Model_iter2');
end
if INRIA
    TrainCropImagepath=['..\data\INRIATrain\' sprintf('w_%f_h_%f',wRatio,hRatio)];
    
    dstCropImagepath=['..\data\ETH\' sprintf('w_%f_h_%f',wRatio,hRatio)];
    ReaderDataFName = [TrainCropImagepath '\CNNDLTData3Color63_4HOGcssNoPosNeg.mat'];
    
    
    load('..\model\INRIA\CNN_CDBN_Model_iter2.mat');
end


load(ReaderDataFName, 'test_x', 'test_y', 'Test_Boxes', 'Test_Frame');

net = cnn_model;
Tbatch_x = [];
TestBatch = 99;
TestBatchNum = floor(size(test_x{1}, 3)/TestBatch);
TestBatchEnd = floor(size(test_x{1}, 3)/TestBatch)*TestBatch;
TestNum = size(test_x{1}, 3);
out = zeros(2, TestNum);
net.layers{3}.mapsize=[19 5];
for l = 1:TestBatchNum %TestBatchEnd
    %             tic;
    for cellidx = 1:length(test_x)
        Tbatch_x{cellidx} = test_x{cellidx}(:, :, (l-1)*TestBatch+1:l*TestBatch);
    end
    
    net = cnnff(net, Tbatch_x);
    if mod(l, 50) == 0
        fprintf('test l: %d(%d)\n', l,TestBatchNum);
    end;
    out(:, (l-1)*TestBatch+1:l*TestBatch) = net.o;
end
for cellidx = 1:length(test_x)
    Tbatch_x{cellidx} = test_x{cellidx}(:, :, TestBatchEnd+1:end);
end
net = cnnff(net, Tbatch_x);
out(:, TestBatchEnd+1:TestNum) = net.o;
if CaltechTrain
    [rs] = testCNNCaltechTest2(out, Test_Boxes, Test_Frame);
end
if INRIA
    [rs] = testCNNAll(out, Test_Boxes, Test_Frame, 1);
end
