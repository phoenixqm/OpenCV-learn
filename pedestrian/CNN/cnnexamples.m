Reload_readear_Data = false; % True: get features again using the bounding boxes detected by the HOG+CSS+SVM
Init_cnn = true;
AfterNMS = true;
% clear all;
close all;
if ~exist('Pathadd', 'var')
    addpath .\gabor
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

TrainCropImagepath=['../data/CaltechTrain/' sprintf('w_%f_h_%f/',wRatio,hRatio)];


TrainCropImagesFName = [TrainCropImagepath 'CaltechTestAllimBoxesBeforeNmsRsz3'];
TrainCropLabelsFName = [TrainCropImagepath 'CaltechTestAllimBoxesBeforeNmsRszLabel3'];
TrainCropBoxesFName = [TrainCropImagepath 'CaltechTestAllimBoxesBeforeNmsRszBox3'];
ReaderDataFName = [TrainCropImagepath 'CNNDLTData3Color63_4.mat'];

dstCropImagepath=['..\data\CaltechTest\' sprintf('w_%f_h_%f',wRatio,hRatio)];
TestCropImagesFName = [dstCropImagepath 'CaltechTestAllimBoxesBeforeNmsRsz2'];
TestCropLabelsFName = [dstCropImagepath 'CaltechTestAllimBoxesBeforeNmsRszLabel2'];
TestCropBoxesFName = [dstCropImagepath 'CaltechTestAllimBoxesBeforeNmsRszBox2'];

if Reload_readear_Data
    load(TrainCropImagesFName,'AllimBoxesBeforeNmsRsz');
    load(TrainCropLabelsFName, 'Labels');
    load(TrainCropBoxesFName, 'Allpartboxes');
    [train_x, train_y, Train_Boxes, Train_Frame] = GetData_datareader(AllimBoxesBeforeNmsRsz, Labels, Allpartboxes, 1, Crop); %
    
    load(TestCropImagesFName, 'AllimBoxesBeforeNmsRsz');
    load(TestCropLabelsFName, 'Labels');
    load(TestCropBoxesFName, 'Allpartboxes');
    [test_x, test_y, Test_Boxes, Test_Frame] = GetData_datareader(AllimBoxesBeforeNmsRsz, Labels, Allpartboxes, 0, Crop);
    save(ReaderDataFName, '-v7.3', 'train_x', 'train_y', 'test_x', 'test_y', 'Test_Boxes', 'Test_Frame', 'Train_Boxes');
    clear AllimBoxesBeforeNmsRsz Labels Allpartboxes;
else
    if ~exist('train_x', 'var') || ~exist('test_x', 'var')
        load(ReaderDataFName, 'train_x', 'train_y', 'test_x', 'test_y', 'Test_Boxes', 'Test_Frame', 'Train_Boxes');
    end
end
%% ex1
sizetrain = size(train_x);
sizeTest = size(test_x);
if Init_cnn || ~isfield(cnn, 'testrs')
    cnn.layers = {
        struct('type', 'i') %input layer
        struct('type', 'c', 'outputmaps', 64, 'kernelsize', 9) %convolution layer
        struct('type', 's', 'scale', 4) %sub sampling layer
        struct('type', 'c', 'outputmaps', 20, 'kernelsize', 9) %convolution layer
        };
    load('./CNNModel_init.mat'); 
    cnn = cnnsetup3(cnn, cnn_model, train_x, train_y, CropSize);
end
cnn.CropSize = CropSize;
opts.alpha = 0.025;
opts.batchsize = 50;
opts.numepochs = 5;

cnn = cnntrain(cnn, AfterNMS, train_x, train_y, opts, test_x, test_y, Test_Boxes, Test_Frame, Train_Boxes);%, test_x, test_y);
plot(cnn.testrs);
plot(cnn.rL);