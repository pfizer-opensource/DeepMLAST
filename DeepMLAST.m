classdef DeepMLAST < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        ProgressTextArea            matlab.ui.control.TextArea
        ProgressTextAreaLabel       matlab.ui.control.Label
        ClearButton                 matlab.ui.control.Button
        RunButton                   matlab.ui.control.Button
        SaveOptionsPanel            matlab.ui.container.Panel
        SaveFullLabelsCheckBox      matlab.ui.control.CheckBox
        OutputsLabel                matlab.ui.control.Label
        Tree                        matlab.ui.container.CheckBoxTree
        TumorNode                   matlab.ui.container.TreeNode
        NonTumorTissueNode          matlab.ui.container.TreeNode
        NormalThoracicNode          matlab.ui.container.TreeNode
        HeartNode                   matlab.ui.container.TreeNode
        ExtraThoracicNode           matlab.ui.container.TreeNode
        LungNode                    matlab.ui.container.TreeNode
        BoneNode                    matlab.ui.container.TreeNode
        BackgroundNode              matlab.ui.container.TreeNode
        SaveFileNameEditField       matlab.ui.control.EditField
        SaveFileNameEditFieldLabel  matlab.ui.control.Label
        SaveQCImagesCheckBox        matlab.ui.control.CheckBox
        ListBox                     matlab.ui.control.ListBox
        ScanSelectionButtonGroup    matlab.ui.container.ButtonGroup
        SelectsubsetButton          matlab.ui.control.RadioButton
        AnalyzeallscansButton       matlab.ui.control.RadioButton
        SelectButton                matlab.ui.control.Button
        StudyFolderEditField        matlab.ui.control.EditField
        StudyFolderEditFieldLabel   matlab.ui.control.Label
        DeepMLASTLabel              matlab.ui.control.Label
    end


    properties (Access = private)
        dirName = 0; % Name of directory to be analyzed
        numScans = 0; % Total number of scans to be analyzed
        allSubfolders = {}; % Cell with list of all folders within the study containing reconstructed mCT scans
        scanSelection = []; % List of scans to be analyzed
        allScanNames = {};% Cell with list of scan names, taken from allSubfolders
    end

    methods (Access = private)

        % Function to locate all scan folders within parent directory
        function findScans(app)
            % Create waitbar
            w = uiprogressdlg(app.UIFigure,'Title','Please Wait',...
                'Message','Scanning Directory for subfolders...',...
                'Indeterminate','On');

            % Get all folders within parent directory
            allSubdirs = strsplit(genpath(app.dirName),';')';
            allSubdirs = allSubdirs(~cellfun('isempty',allSubdirs));

            % Only use directories with *rec0* and without *_voi_*
            n = 0; allScanDirs = {};
            w.Indeterminate = 'Off';
            w.Message = 'Scanning subfolders for mCT scans...';
            for parInd = 1:numel(allSubdirs)
                % Update waitbar
                % Check if folder contains mCT scan
                if ~isempty(dir([allSubdirs{parInd} '\*rec0*'])) && isempty(dir([allSubdirs{parInd} '\*_voi_*']))
                    w.Value = parInd/numel(allSubdirs);
                    n = n + 1;
                    allScanDirs{n} = allSubdirs{parInd};
                end
            end
            app.allSubfolders = allScanDirs;
            app.numScans = n;
            close(w);
        end

        function varIn = packInputs(app)
            % Properties
            varIn.dirName = app.dirName;
            varIn.numScans = app.numScans;
            varIn.scanFolders = app.allSubfolders(app.scanSelection);
            varIn.scanNames = app.allScanNames(app.scanSelection);

            % Save Options
            varIn.saveName = rmFileExt(app.SaveFileNameEditField.Value);
            varIn.saveQC = app.SaveQCImagesCheckBox.Value;
            varIn.saveFullLabels = app.SaveFullLabelsCheckBox.Value;
            nodes = app.Tree.CheckedNodes; out = {};
            for i = 1:numel(nodes)
                out{i} = nodes(i).Text;
            end
            varIn.saveOutputs = out';
        end



        % Function to update progress window to guide user
        function updateProgress(app,msg)
            app.ProgressTextArea.Value = msg;
        end

        % Function to reset defaults and either enable or disable buttons
        function resetDefaults(app,enable)
            % Enable/disable buttons
            app.ScanSelectionButtonGroup.Enable = enable;
            app.SelectsubsetButton.Enable = enable;
            app.AnalyzeallscansButton.Enable = enable;
            app.ListBox.Enable = enable;
            app.SaveOptionsPanel.Enable = enable;
            app.SaveFileNameEditFieldLabel.Enable = enable;
            app.SaveFileNameEditField.Enable = enable;
            app.SaveQCImagesCheckBox.Enable = enable;
            app.SaveFullLabelsCheckBox.Enable = enable;
            app.Tree.Enable = enable;
            app.OutputsLabel.Enable = enable;
            app.ProgressTextArea.Enable = enable;
            app.ProgressTextAreaLabel.Enable = enable;
            app.RunButton.Enable = enable;

            % Set defaults
            app.SaveFileNameEditField.Value = 'DeepMLAST';
            app.SaveQCImagesCheckBox.Value = 1;
            app.SaveFullLabelsCheckBox.Value = 1;
            app.Tree.CheckedNodes = [app.TumorNode, app.NormalThoracicNode,...
                app.LungNode, app.HeartNode];

            % Reset scan selection
            app.ScanSelectionButtonGroup.SelectedObject = app.AnalyzeallscansButton;
            app.ScanSelectionButtonGroupSelectionChanged(app);
        end

        
        function changeMind = confirmOverwriteDir(app)
            outDir = fullfile(app.dirName,app.SaveFileNameEditField.Value);
            if exist(outDir,'dir')==7
                changeMind = uiconfirm(app.UIFigure,[outDir ' already exists. Do you want to overwrite?'],'Confirm Overwrite');
            else 
                changeMind = '';
            end
        end
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectButton
        function SelectButtonPushed(app, event)
            if app.dirName == 0
                stDir = '\*.*';
            else
                stDir = app.dirName;
            end
            tmpDirName = uigetdir(stDir,'Please Select Study Directory');
            app.UIFigure.Visible = 'off';
            app.UIFigure.Visible = 'on';
            % Double check valid directory selected
            if tmpDirName == 0
                return;
            else
                app.dirName = tmpDirName;
            end

            % Update study name
            app.StudyFolderEditField.Value = app.dirName;

            % Read study folder for scan list
            app.findScans();
            app.allScanNames = {};

            % Parse scan names by folder name
            w = uiprogressdlg(app.UIFigure,'Title','Please Wait','Message',...
                'Parsing Scan Names','Value',0);
            for scanInd = 1:app.numScans
                w.Value = scanInd/app.numScans;
                app.allScanNames{scanInd} = parseDirName(app.allSubfolders{scanInd},app.dirName);
            end
            [app.allScanNames, sortOrder] = sortFileList2(app.allScanNames);
            app.allSubfolders = app.allSubfolders(sortOrder);
            app.scanSelection = 1:app.numScans;

            % Set next GUI Items
            app.resetDefaults('on')

            close(w);
            
            % Warn user if no data found
            if numel(app.scanSelection) == 0
                uialert(app.UIFigure,'No scans found within directory. Please select a directory containing files fitting a *rec0* format.','No data found','Icon','Warning');
                app.resetDefaults('off');
            end
        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)
            % Reset variables
            app.dirName = 0;
            app.numScans = 0;
            app.allSubfolders = {};
            app.scanSelection = [];
            app.allScanNames = {};

            % Clear fields
            app.StudyFolderEditField.Value = '';
            app.SaveFileNameEditField.Value = '';

            % Disable GUI items
            app.resetDefaults('off')
        end

        % Selection changed function: ScanSelectionButtonGroup
        function ScanSelectionButtonGroupSelectionChanged(app, event)
            selectedButton = app.ScanSelectionButtonGroup.SelectedObject;
            if strcmp(selectedButton.Text,'Select subset')
                % Enable selection list
                app.ListBox.Items = app.allScanNames;
                app.ListBox.Enable = 'on';
                app.ListBox.Value = app.ListBox.Items(app.scanSelection);
                updateProgress(app,[num2str(length(app.scanSelection)) ' scans selected']);
            else
                % Disable selection list
                app.scanSelection = 1:app.numScans;
                app.ListBox.Items = {};
                app.ListBox.Enable = 'off';
                app.ListBox.Value = {};
                updateProgress(app,[num2str(length(app.scanSelection)) ' scans selected']);
            end
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            changeMind = confirmOverwriteDir(app);
            if strcmp(changeMind,'Cancel')
                return
            end

            runStat = struct;
            runStat.errMsg = '';
            runStat.status = 'Successful';
            tic;

            % Prepare inputs
            try
                updateProgress(app,'Preparing Inputs...')
                varIn = app.packInputs();

                % Update user
                updateProgress(app,'Running...')
                w = uiprogressdlg(app.UIFigure,'Title','Please Wait',...
                    'Message','Running analysis...',...
                    'Indeterminate','On');

                % Run function
                results = deepMLASTmain(varIn);
            catch ME
                runStat.errMsg = ME.message;
                runStat.status='Unsuccessful';
                results = emptyResults();
            end
            writeDeepMLASTlog(fullfile(app.dirName,'DeepMLASTlog.txt'),varIn,results,runStat,toc)

            % Alert user
            close(w)
            updateProgress(app,'Finished!')
            if strcmp(runStat.status,'Successful')
                uialert(app.UIFigure,'Analysis Complete!','Finished','Icon','success');
            else
                uialert(app.UIFigure,...
                    ['Error: ' runStat.errMsg '. Please check the log file for more information'],...
                    'Error','Icon','error');
            end

        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            value = app.ListBox.Value;
            pickNums = zeros(numel(value),1);
            % Get indices of selections
            for i = 1:numel(value)
                pickNums(i) = find(strcmp(value{i},app.ListBox.Items));
            end
            pickNums = sort(pickNums);
            app.scanSelection = pickNums;
            app.ScanSelectionButtonGroupSelectionChanged();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create DeepMLASTLabel
            app.DeepMLASTLabel = uilabel(app.UIFigure);
            app.DeepMLASTLabel.FontSize = 28;
            app.DeepMLASTLabel.FontWeight = 'bold';
            app.DeepMLASTLabel.FontColor = [1 0.4118 0.1608];
            app.DeepMLASTLabel.Position = [232 435 178 34];
            app.DeepMLASTLabel.Text = 'Deep MLAST';

            % Create StudyFolderEditFieldLabel
            app.StudyFolderEditFieldLabel = uilabel(app.UIFigure);
            app.StudyFolderEditFieldLabel.HorizontalAlignment = 'right';
            app.StudyFolderEditFieldLabel.Position = [12 393 77 22];
            app.StudyFolderEditFieldLabel.Text = 'Study Folder:';

            % Create StudyFolderEditField
            app.StudyFolderEditField = uieditfield(app.UIFigure, 'text');
            app.StudyFolderEditField.Editable = 'off';
            app.StudyFolderEditField.Position = [104 393 439 22];

            % Create SelectButton
            app.SelectButton = uibutton(app.UIFigure, 'push');
            app.SelectButton.ButtonPushedFcn = createCallbackFcn(app, @SelectButtonPushed, true);
            app.SelectButton.Position = [551 393 75 22];
            app.SelectButton.Text = 'Select';

            % Create ScanSelectionButtonGroup
            app.ScanSelectionButtonGroup = uibuttongroup(app.UIFigure);
            app.ScanSelectionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ScanSelectionButtonGroupSelectionChanged, true);
            app.ScanSelectionButtonGroup.Enable = 'off';
            app.ScanSelectionButtonGroup.Title = 'Scan Selection';
            app.ScanSelectionButtonGroup.Position = [21 312 241 70];

            % Create AnalyzeallscansButton
            app.AnalyzeallscansButton = uiradiobutton(app.ScanSelectionButtonGroup);
            app.AnalyzeallscansButton.Enable = 'off';
            app.AnalyzeallscansButton.Text = 'Analyze all scans';
            app.AnalyzeallscansButton.Position = [11 24 115 22];
            app.AnalyzeallscansButton.Value = true;

            % Create SelectsubsetButton
            app.SelectsubsetButton = uiradiobutton(app.ScanSelectionButtonGroup);
            app.SelectsubsetButton.Enable = 'off';
            app.SelectsubsetButton.Text = 'Select subset';
            app.SelectsubsetButton.Position = [11 2 94 22];

            % Create ListBox
            app.ListBox = uilistbox(app.UIFigure);
            app.ListBox.Items = {};
            app.ListBox.Multiselect = 'on';
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Enable = 'off';
            app.ListBox.Position = [21 19 241 284];
            app.ListBox.Value = {};

            % Create SaveOptionsPanel
            app.SaveOptionsPanel = uipanel(app.UIFigure);
            app.SaveOptionsPanel.Enable = 'off';
            app.SaveOptionsPanel.Title = 'Save Options';
            app.SaveOptionsPanel.Position = [283 147 343 235];

            % Create SaveQCImagesCheckBox
            app.SaveQCImagesCheckBox = uicheckbox(app.SaveOptionsPanel);
            app.SaveQCImagesCheckBox.Enable = 'off';
            app.SaveQCImagesCheckBox.Text = 'Save QC Images';
            app.SaveQCImagesCheckBox.Position = [8 134 113 22];
            app.SaveQCImagesCheckBox.Value = true;

            % Create SaveFileNameEditFieldLabel
            app.SaveFileNameEditFieldLabel = uilabel(app.SaveOptionsPanel);
            app.SaveFileNameEditFieldLabel.HorizontalAlignment = 'right';
            app.SaveFileNameEditFieldLabel.Enable = 'off';
            app.SaveFileNameEditFieldLabel.Position = [11 183 94 22];
            app.SaveFileNameEditFieldLabel.Text = 'Save File Name:';

            % Create SaveFileNameEditField
            app.SaveFileNameEditField = uieditfield(app.SaveOptionsPanel, 'text');
            app.SaveFileNameEditField.Enable = 'off';
            app.SaveFileNameEditField.Position = [120 183 212 22];

            % Create Tree
            app.Tree = uitree(app.SaveOptionsPanel, 'checkbox');
            app.Tree.Enable = 'off';
            app.Tree.Position = [155 11 176 122];

            % Create TumorNode
            app.TumorNode = uitreenode(app.Tree);
            app.TumorNode.Text = 'Tumor';

            % Create NonTumorTissueNode
            app.NonTumorTissueNode = uitreenode(app.Tree);
            app.NonTumorTissueNode.Text = 'Non-Tumor Tissue';

            % Create NormalThoracicNode
            app.NormalThoracicNode = uitreenode(app.NonTumorTissueNode);
            app.NormalThoracicNode.Text = 'Normal Thoracic';

            % Create HeartNode
            app.HeartNode = uitreenode(app.NonTumorTissueNode);
            app.HeartNode.Text = 'Heart';

            % Create ExtraThoracicNode
            app.ExtraThoracicNode = uitreenode(app.NonTumorTissueNode);
            app.ExtraThoracicNode.Text = 'Extra-Thoracic';

            % Create LungNode
            app.LungNode = uitreenode(app.Tree);
            app.LungNode.Text = 'Lung';

            % Create BoneNode
            app.BoneNode = uitreenode(app.Tree);
            app.BoneNode.Text = 'Bone';

            % Create BackgroundNode
            app.BackgroundNode = uitreenode(app.Tree);
            app.BackgroundNode.Text = 'Background';

            % Create OutputsLabel
            app.OutputsLabel = uilabel(app.SaveOptionsPanel);
            app.OutputsLabel.FontWeight = 'bold';
            app.OutputsLabel.Enable = 'off';
            app.OutputsLabel.Position = [155 134 55 22];
            app.OutputsLabel.Text = 'Outputs:';

            % Create SaveFullLabelsCheckBox
            app.SaveFullLabelsCheckBox = uicheckbox(app.SaveOptionsPanel);
            app.SaveFullLabelsCheckBox.Enable = 'off';
            app.SaveFullLabelsCheckBox.Text = 'Save Full Labels';
            app.SaveFullLabelsCheckBox.Position = [8 106 111 22];
            app.SaveFullLabelsCheckBox.Value = true;

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.BackgroundColor = [0.8353 0.9608 0.6706];
            app.RunButton.FontWeight = 'bold';
            app.RunButton.Enable = 'off';
            app.RunButton.Position = [340 19 100 22];
            app.RunButton.Text = 'Run';

            % Create ClearButton
            app.ClearButton = uibutton(app.UIFigure, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.BackgroundColor = [0.9608 0.5373 0.5373];
            app.ClearButton.FontWeight = 'bold';
            app.ClearButton.Position = [515 19 100 22];
            app.ClearButton.Text = 'Clear';

            % Create ProgressTextAreaLabel
            app.ProgressTextAreaLabel = uilabel(app.UIFigure);
            app.ProgressTextAreaLabel.HorizontalAlignment = 'right';
            app.ProgressTextAreaLabel.Enable = 'off';
            app.ProgressTextAreaLabel.Position = [283 115 57 22];
            app.ProgressTextAreaLabel.Text = 'Progress:';

            % Create ProgressTextArea
            app.ProgressTextArea = uitextarea(app.UIFigure);
            app.ProgressTextArea.Editable = 'off';
            app.ProgressTextArea.Enable = 'off';
            app.ProgressTextArea.Position = [284 56 342 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DeepMLAST

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end