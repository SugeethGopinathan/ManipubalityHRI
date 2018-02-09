clear;
%% read data in data file and save in table
A = importdata('calib.dat'); % A = importdata('report.dat')
calib = array2table(A.data);
calib.Properties.VariableNames = strrep(A.textdata,'.','');

manip = calib.manipmanip_measure_out_port;
f_trans = calib.manipforce_transmission_out_port;
time = calib.TimeStamp;



%% HistFit for manip

figure
histdata_m = hist(manip,200,'normal',1);
histfit(manip,200,'normal')

max(histdata_m)/100

fit_data_m = fitdist(manip,'normal');

m_Uplimit  = norminv(.98, fit_data_m.mu, fit_data_m.sigma)

title("Manipulability Calibration")


%% HistFit for f_trans
figure
histdata_ft = hist(f_trans,200,'normal',1);
histfit(f_trans,200,'normal')

max(histdata_ft)/100

fit_data_ft = fitdist(f_trans,'normal');

ft_Uplimit  = norminv(.98, fit_data_ft.mu, fit_data_ft.sigma)


title("Force Transmission Ratio Calibration")

%% Filtering

[B,Aa] = butter(3,.05);


filt_manip = filter(B,Aa, manip);
filt_ft = filter(B,Aa,f_trans);

plotyy(time,filt_manip,time,filt_ft)

%% Writing the limits to the corresponding files

fileID = fopen('/home/kukalwr/git_repos/ManipubalityHRI/rtt-forceTrans-to-stiffness/ops-scripts/Ft_max.txt','w');
fprintf(fileID,'%d',ft_Uplimit);
fclose(fileID);
prompt1 = ' Enter FT low limit ';
ft_Lowlimit = input(prompt1);
fileID = fopen('/home/kukalwr/git_repos/ManipubalityHRI/rtt-forceTrans-to-stiffness/ops-scripts/Ft_min.txt','w');
fprintf(fileID,'%d',ft_Lowlimit);
fclose(fileID);

fileID = fopen('/home/kukalwr/git_repos/ManipubalityHRI/rtt-manip-to-stiffness/ops-scripts/manip_max.txt','w');
fprintf(fileID,'%d',m_Uplimit);
fclose(fileID);
prompt2 = ' Enter manip low limit ';
m_Lowlimit = input(prompt2);
fileID = fopen('/home/kukalwr/git_repos/ManipubalityHRI/rtt-manip-to-stiffness/ops-scripts/manip_min.txt','w');
fprintf(fileID,'%d',m_Lowlimit);
fclose(fileID);
