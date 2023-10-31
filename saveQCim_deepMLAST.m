% Function to create and save QC images for a segmentation of a single
% scan.
function saveQCim_deepMLAST(dirName,saveFileName,rawIm,labelIm)
% Check inputs
checkArgs(dirName,saveFileName,rawIm,labelIm);

% ------------------ Get Images ------------------

% Locate slice to use in each dimension
sliceNums = findBestSlice(labelIm==7);

% Get images of these slices
rawX = squeeze(rawIm(sliceNums(1),:,:));
labelX = squeeze(labelIm(sliceNums(1),:,:));
rawY = squeeze(rawIm(:,sliceNums(2),:));
labelY = squeeze(labelIm(:,sliceNums(2),:));
rawZ = squeeze(rawIm(:,:,sliceNums(3)));
labelZ = squeeze(labelIm(:,:,sliceNums(3)));

% Rotate coronal view
rawX = imrotate(rawX,90);
labelX = imrotate(labelX,90);
clear rawIm labelIm
% ------------------ Generate figure ------------------
labelMap = [0 0 0; .8 .8 .8; 1 .5 0; 0 0 1; 0 1 0; 1 0 0; 1 0 1];
labelMapLegend = '\color{gray}Bone \color{white}/ \color{orange}Thoracic Tissue \color{white}/ \color{blue}Lung \color{white}/ \color{green}Diaphragm \color{white}/ \color{red}Heart \color{white}/ \color{magenta}Tumor';
figure('color','black','Name',saveFileName);
% Display raw images
subplot(2,3,1);
imagesc(rawX); colormap(gca,'gray'); axis image on; title('\color{white}Coronal')
set(gca,'xtick',[],'xticklabels',{},'ytick',[size(rawX,1)/2],'yticklabels',{'\color{white}mCT Image'},'fontweight','bold');
subplot(2,3,2);
imagesc(rawY); colormap(gca,'gray'); axis image off; title('\color{white}Sagittal')
subplot(2,3,3);
imagesc(rawZ); colormap(gca,'gray'); axis image off; title('\color{white}Axial')
% Display labels
subplot(2,3,4);
imagesc(labelX); colormap(gca,labelMap); axis image on; caxis([1 size(labelMap,1)]);
set(gca,'xtick',[],'xticklabels',{},'ytick',[size(rawX,1)/2],'yticklabels',{'\color{white}Segmentation'},'fontweight','bold');
subplot(2,3,5);
imagesc(labelY); colormap(gca,labelMap); axis image off; caxis([1 size(labelMap,1)]);
subplot(2,3,6);
imagesc(labelZ); colormap(gca,labelMap); axis image off; caxis([1 size(labelMap,1)]);
% Add color legend
subplot(234);
text(-25,size(rawX,1)+100,labelMapLegend,'fontsize',12,'fontweight','bold');
set(gcf,'InvertHardcopy','off');
saveas(gcf,verifyFileName(fullfile(dirName,saveFileName)),'png')
close;
end



function checkArgs(dirName,saveFileName,rawIm,labelIm)
% dirName
checkDir(dirName,'saveQCim_deepMLAST');
% saveFileName
if ~ischar(saveFileName)
    error('saveQCim_deepMLAST:InvalidSaveName',...
        'Invalid save name: saveFileName must be a character');
end

% Images
checkIm(rawIm,3,'saveQCim_deepMLAST');
checkIm(labelIm,3,'saveQCim_deepMLAST');

% Check dimensionality of data is same
if ~isequal(size(rawIm),size(labelIm))
    error('saveQCim_deepMLAST:DimensionMismatch',...
        'Error saving QC image: Raw image and segmentation dimensionality mismatch');
end
end