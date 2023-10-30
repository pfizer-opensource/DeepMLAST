# DeepMLAST
Deep learning project for automated semantic segmentation of spontaneous lung tumors in murine microCT 

## Application Description
Deep MLAST is a Matlab-based application which applies a deep learning model to perform semantic segmentation of thoracic mCT scans of naïve and lung tumor-bearing mice. 
The deep learning model is based off Ronneberger et al.’s U-Net and classifies all pixels in a 2D image as one of:
1.	  Background
2.	  Bone
3.	  Normal Thoracic Tissue
4.	  Lung
5.	  Extra-thoracic tissue (diaphragm and below)
6.	  Heart
7.	  Tumor
 
The model is applied to all slices in a 3D mCT scan, and volumes for each tissue type are calculated. Depending on the user selections, some or all of the volumes are reported in a .csv. 
The application also saves the full segmentation labels for each image, as well as a snapshot (one slice in each orientation) of the segmentations for QC purposes.

## The Model
The deep learning model is based on a U-Net, a convolutional deep neural net architecture published by Ronneberger et al. in the 2015 ImageNet challenge. 
This model is popular for semantic segmentation of medical images because of its ability to capture both high-level and low-level features. 
The model was trained on 100 manually-segmented scans of GEMM KP (50 KrasLSL-G12D/WTp53fl/fl and 50 KrasLSL-G12C/WTp53fl/fl) C57BL/6 mice that had been visually categorized according to their tumor burden. 
25 score 0 (no tumor), 25 score 1, 25 score 2, and 25 score 3 (heavy tumor burden) scans were segmented into 7 tissue categories: 
background, bone, normal thoracic tissue, lung, extra-thoracic tissue, heart, and tumor. 
Training was performed with a 64-16-20 train-validation-test split, and a data augmentation paradigm that included a horizontal flip, a horizontal and vertical shift of +/- 10%, and a rotational range of +/- 60 degrees. 
The model was trained using a dice similarity coefficient-based loss function, an Adam optimizer, and a batch size of 32 epochs over 100 epochs or until early stopping criteria was met. Training time was approximately 7 hours. 
The model achieved a high overlap of the tumor label with the manually segmented ground-truth dataset (DCS=0.781) and a high correlation of calculated tumor volumes with those calculated from the ground-truth data (r-squared = 0.99). 

## Input Data
Please note that this application is only designed to be used on 3D microCT scans acquired in either tiff (.tif) or bitmap (.bmp) format by a Bruker SkyScan 1278 at 100 micron resolution with a 0.5mm Al filter and 
reconstructed using Bruker’s NRecon software. The application expects data to be stored in a hierarchical folder structure, with levels corresponding to some or all of treatment group, subject ID, and timepoint.

## Using the Application

1.	Launching the application – To launch the application, run DeepMLAST.m in Matlab R2019.a. Note that the application was written in Matlab 2019.a, and may encounter errors if run in another version. 
2.	Selecting a study – Running the application will launch a graphical user interface (GUI) titled “Deep MLAST” (as well as a black console window). 
	Only one button will be enabled – the Study Folder “Select” button. Click this button and select the folder of the study which you want to analyze. 
	Note that the application will only find scans that are saved somewhere within this study folder, so the user should select a folder level under which all scans are included.
3.	Selecting scans – By default, all scans found within the study folder will be selected, but if the user wants to analyze a subset or even just to view a list of the scans found, 
	they can select the “Select subset” radio button under the “Scan Selection” panel. A single scan, multiple scans, or all scans can be selected with the typical windows “ctrl-click” (select multiple individual files), 
	“ctrl-shift-click” (select all files in a range), and “ctrl-a” (select all files) shortcuts. The progress window in the lower right corner of the GUI will indicate the number of scans currently selected.
4.	Setting save options – The user can set any desired save options or can use the defaults for all
  *	Save File Name – This is the name of the subfolder under which all save files (except the log) will be saved. The default is “DeepMLAST”.
  *	Save QC Images – This checkbox instructs the application to save a single QC image for each scan to be analyzed containing both a grayscale mCT slice and a color-coded label image for the same slice in all 3 orientations. This box is checked by default.
  *	Save Full Labels – This checkbox instructs the application to save a full tif stack of segmentation label images for each scan to be analyzed. This box is checked by default.
  *	Output Tissues – This series of checkbox indicates the tissues for which the resulting volumes will be calculated and saved to an .xlsx file. 
		The default selection is tumor, normal thoracic tissue, heart, and lung, but users have the option to also select extra-thoracic tissue, bone, and background. 
		Each tissue’s volumetric calculations will be written to a separate tab within the .xlsx file.
6.	Running the application – To run the application, simply click the green “Run” button. Depending on the size of the study, Deep MLAST may take a long time to analyze the data. 
	During this time, an indeterminate waitbar will flash across the GUI window, and the black console window will provide text updates on how many scans have been analyzed.

## Application Outputs
The Deep MLAST application saves 4 items. All items except the log file are saved in a subfolder within the study named whatever the user sets as the “Save File Name”. The default is “DeepMLAST”.
1.	XLSX file – The application saves a single .xlsx file containing volume measurements for the tissues selected in the “Outputs” list in the GUI. 
	The default includes Tumor, Normal Thoracic Tissue, Heart, and Lung. 
	Each output tissue has its own tab containing the volume measurements (in mm^3) organized in a table with each subject in its own column and each time point in its own row. 
	This table is designed so the data can be quickly copied into GraphPad Prism, and the group/subject/timepoint information is parsed from first the folder structure then the image filename. 
	The .xlsx file is saved in the run’s subfolder within the study folder, and is named whatever the user sets as the “Save File Name”. The default is “DeepMLAST/DeepMLAST.xlsx”.
2.	QC Images (optional) – The application saves a single QC  image for each 3D scan it analyzes. These contain both a grayscale mCT slice and a color-coded label image for the same slice in all 3 orientations. 
	All QC images are saved in a “QC Images” subfolder within the run subfolder within the study folder. The user has the option to skip saving these images by unchecking the “Save QC Images” checkbox on the GUI.
3.	Full Segmentation Labels (optional) – The application saves a subfolder containing a stack of segmentation label images in tif format. 
	For each scan in the dataset, a single subfolder is created containing as many label images as mCT slices in the original dataset. The images contain pixels in the range 0 to 6, which correspond to the following tissues:
* 0: Background
*	1: Bone
*	2: Normal thoracic tissue
*	3: Lung
*	4: Extra-thoracic tissue
*	5: Heart
*	6: Tumor
	The user has the option to skip saving these images by unchecking the “Save Full Labels” checkbox on the GUI.
4.	Log file – In the study folder (not the run’s subfolder), the application saves a single log file, named “DeepMLASTlog.txt” for all Deep MLAST runs of the study. 
	This file is re-written with each successive run, with newer runs at the bottom. The log file contains run metadata, such as when the run was completed, who performed it, how long it took, and what input settings were selected.
