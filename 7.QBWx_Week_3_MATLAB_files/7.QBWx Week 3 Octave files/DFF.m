% STEP 1: LOAD THE TEXT FILE CONTAINING FLUORESCENCE DATA FROM IMAGEJ

A = importdata('Results.txt');
rawData = A.data';
rawF = rawData(2:end,:);

% STEP 2:  COMPUTING THE CHANGE IN FLUORESCENCE RELATIVE TO BASELINE OF EACH CELL

% Calculate and Plot DFF for One Cell

cell = 1; % this is the cell we will extract

rawF_cell = rawF(cell,:);
rawF_rounded = round(rawF_cell/10)*10;;
baseline = mode(rawF_rounded);
dff_cell = (rawF_cell-baseline)/baseline;

        
subplot(2,1,1)
plot(rawF_cell)
ylabel('raw F')
axis tight        
        
subplot(2,1,2)
plot(dff_cell)
ylabel('DFF')
axis tight


% Generate DFF Matrix for All Cells

NumCells = size(rawF,1);    

      
for cell=1:NumCells
    
    rawF_cell = rawF(cell,:);
    rawF_rounded = round(rawF_cell/10)*10;
    baseline = mode(rawF_rounded);

    dff_cell = (rawF_cell-baseline)/baseline;

        
    DFF(cell,:) = dff_cell;
        
end

% INTERPOLATE THE DFF TRACES

old_length = size(DFF,2); % number of columns
new_length = 2880; % 5fps * 576seconds

for cell = 1:NumCells

   DFF_cell = DFF(cell,:); 

   % store the interpolated vector in a row of the DFF_new matrix
   DFF_new(cell,:) = interp1(DFF_cell,linspace(1,old_length,new_length));

end
DFF = DFF_new; % replace matrix with interpolated one

% STEP 3: PLOTTING THE RESPONSES FOR ONE CELL TO EACH ORIENTATION


FrameRate = 5;
SamplesPerTrial = 480;
NumTrials = 6;
cell = 1; % this is the cell that we will analyze
        
dff_cell = DFF(cell,:); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerTrial,NumTrials);
dff_avg = mean(dff_reshaped, 2);

% plot dff_avg        
t = (0:SamplesPerTrial-1)/FrameRate;
plot(t,dff_avg)
hold on;

% plot bars indicating ON period
for i = 1:12
	plot([8*i-4,8*i],min(dff_avg)*ones(1,2),'r','LineWidth',3)
end
xlabel('Time (s)')
ylabel('\DeltaF/F')

% STEP 4: PLOTTING AN ORIENTATION TUNING CURVE

% Calculate Time-Averaged ON and OFF Responses

SamplesPerOri = 40;
NumOrientations = 12;
NumTrials =6;
cell = 1; % this is the cell that we will analyze
        
dff_cell = DFF(cell,:); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerOri,NumOrientations,NumTrials);

ON_period = 21:40;
OFF_period = 11:20;
        
AveON = mean(dff_reshaped(ON_period,1:NumOrientations,1:NumTrials), 1);
AveOFF = mean(dff_reshaped(OFF_period,1:NumOrientations,1:NumTrials), 1);

AveON = squeeze(AveON);
AveOFF = squeeze(AveOFF);        
      
% Plot the Tuning Curve

NumTrials = 6;
Orientations = 0:30:330;
        
ON_mean = mean(AveON,2);
ON_sem = std(AveON, [], 2) / sqrt(NumTrials);
OFF_mean = mean(mean(AveOFF));
OFF_line = OFF_mean*ones(size(Orientations)); 

figure
hold on
errorbar(Orientations,ON_mean,ON_sem,'b') % plot ON tuning curve       
plot(Orientations,OFF_line,'r') % plot OFF spontaneous activity
xlim([-30 360])
ylim([min(ylim)-0.1, max(ylim)])
xlabel('Orientation (deg)')
ylabel('\DeltaF/F')

% STEP 5: PLOTTING TUNING CURVES FOR ALL CELLS

% Calculate Time-Averaged ON and OFF Responses

      
NumCells = size(DFF,1);

NumOrientations=12;
NumTrials=6;
SamplesPerOri=40;
        
        
% initialize matrices
AveON = zeros(NumCells,NumOrientations,NumTrials);
AveOFF = zeros(NumCells,NumOrientations,NumTrials);

for cell = 1:NumCells            
        
dff_cell = DFF(cell,:); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerOri,NumOrientations,NumTrials);

ON_period = 21:40;
OFF_period = 11:20;
        
AveONcell = mean(dff_reshaped(ON_period,1:NumOrientations,1:NumTrials), 1);
AveOFFcell = mean(dff_reshaped(OFF_period,1:NumOrientations,1:NumTrials), 1);        
        
    AveON(cell,1:NumOrientations,1:NumTrials) = AveONcell;
    AveOFF(cell,1:NumOrientations,1:NumTrials) = AveOFFcell;
end

% Plot Multiple Tuning Curves

NumCells = size(DFF,1);
Orientations = 0:30:330;
NumTrials = 6;
        
ON_mean = mean(AveON,3);
ON_sem = std(AveON, [], 3) / sqrt(NumTrials);
        
OFF_mean = mean(mean(AveOFF,3),2);
size(OFF_mean);

for cell = 1:8
    subplot(2,4,cell)
    
    OFF_line = OFF_mean(cell)*ones(size(Orientations)); 
        
	hold on
	errorbar(Orientations,ON_mean(cell,1:end,1:end),ON_sem(cell,1:end,1:end),'b') % plot ON tuning curve       
	plot(Orientations,OFF_line,'r') % plot OFF spontaneous activity
	xlim([-30 360])
	ylim([min(ylim)-0.1, max(ylim)])
  
  % STEP 6: COMPUTING POPULATION STATISTICS
  
  % Subtract and Threshold Tuning Curve
  
  NumCells=size(DFF,1);

NumOrientations = 12;
        
OFF_mean = repmat(OFF_mean,1,NumOrientations); 

TC = ON_mean-OFF_mean;
TC(TC<0) = 0;        
        
% Plot Histograms of Preferred Orientation and OSI

NumCells = size(DFF,1);
Orientations = 0:30:330;
AngRad = Orientations*pi/180;        

% initialize your vectors        
AllOSI = zeros(1,NumCells);
AllPO = zeros(1,NumCells);
        
for cell=1:NumCells
    
    TC_cell = TC(cell,1:end);

OSI = abs(sum(TC_cell.*exp(2.*1i.*AngRad))./sum(TC_cell));
 PrefOri = 0.5.*( angle( sum(TC_cell.*exp(2.*1i.*AngRad)) ) );
 PO = PrefOri.*(180/pi);
 if PO < 0
 PO = PO+180;
 end
        
    AllOSI(cell) = OSI;
    AllPO(cell) = PO;    
        
end
        
subplot(1,2,1)        
hist(AllOSI)      
xlabel('OSI')        
subplot(1,2,2)
hist(AllPO)  
xlabel('Preferred Orientation (deg)')
      
        
end
     
% STEP 7: GENERATING A POPULATION ORIENTATION MAP

% Generate the Map 

size(ROIs);
NumCells = size(DFF,1);  
NumTrials=6;
NumOrientations=12;
        
% display average projection image
image(img) 
axis square

% setup colors
color = hsv(180); 

% loop for each cell
for cell = 1:NumCells
    
    % get ROI coordinates
    roi = ROIs{1,cell}.mnCoordinates;    
    
    % color based on preferred orientation	        
    if max(TC(cell,1:end)) == 0  % not visually responsive = black
        roicolor = zeros(1,3); 
        
    elseif AllOSI(cell) < 0.25 % broadly tuned = white
        roicolor = ones(1,3); 
        
    else % not visually responsive
        roicolor = color(ceil(AllPO(cell)),:);
        
    end    
    
    % draw colored ROI
    patch(roi(:,1),roi(:,2),ones(1,size(roi,1)),'FaceColor',roicolor)    
end     
        
colormap(color)
colorbar('Ticks',[0:60:360]/180, 'TickLAbels',0:30:180)
axis off
title('Population Orientation Map')
      