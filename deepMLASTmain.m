function results = deepMLASTmain(varIn)
% Main function to apply Deep MLAST model to all scans in a study

% Create Save Folders
saveDir = fullfile(varIn.dirName,varIn.saveName);
mkdir(saveDir);
if varIn.saveQC == 1
    qcDir = fullfile(saveDir,'QC Images');
    mkdir(qcDir);
end

% Ignore warning. Have tested and confirmed keras model performs same in
% Matlab as in Python
warning('off','nnet_cnn_kerasimporter:keras_importer:KerasVersionTooNew');
% Load model
model = importKerasNetwork('model_weights.h5');

% Preallocate
numLabels = 7;
allResults = cell(numel(varIn.scanNames),numLabels+1);
allResults(:,1) = varIn.scanNames';
tmpResults = cell(numel(varIn.scanNames),numLabels);
for scan_n = 1:numel(varIn.scanFolders)
    scanDir = varIn.scanFolders{scan_n};
    
    % Read scan
    [fileList, mNum, scanDate, fileType] = scanInfo(scanDir,varIn.scanFolders);
    rawIm = loadScan(scanDir, fileList, fileType);
    dz = size(rawIm,3);
    
    % Get volume conversion factor
    scanRes = str2double(readLogFile(getLogFile(scanDir),'ImagePixelSize(um)','ScaledImagePixelSize(um)'));
    scanRes = scanRes * 0.001; %Convert from um to mm
    volFactor = scanRes*scanRes*scanRes;
    
    % Preallocate label image
    labelIm = zeros(256,256,dz);
    prepIm = zeros(256,256,dz);
    for z = 1:dz
        % Pre-process
        prepIm(:,:,z) = preprocessIm(rawIm(:,:,z));
        
        % Apply model
        C = semanticseg(prepIm(:,:,z), model);
        labelIm(:,:,z) = uint8(C);
    end
    % Write full label image
    if varIn.saveFullLabels
        writeImgStack(labelIm,varIn.scanNames{scan_n},saveDir,'.tif'),
    end
    
    % Save QC Image
    if varIn.saveQC
        saveQCim_deepMLAST(qcDir,varIn.scanNames{scan_n},prepIm,labelIm);
    end
    
    % Save results
    tmpResults(scan_n,:) = calcResults(labelIm,numLabels,volFactor);
end
allResults(:,2:end) = tmpResults;
% Write results to Excel file
results = conv2table(allResults);
write2Excel(verifyFileName(fullfile(saveDir,[varIn.saveName '.xlsx'])), results, varIn.saveOutputs);


end













