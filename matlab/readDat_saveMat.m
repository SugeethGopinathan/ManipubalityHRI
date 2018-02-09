clear;
%% read data in data file and save in table
A = importdata('benchmark.dat'); % A = importdata('report.dat')
manip = array2table(A.data);
manip.Properties.VariableNames = strrep(A.textdata,'.','');

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

%plotyy(time,filt_manip,time,filt_ft)

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


%% Correcting the TCP

% load
%% relative Coordinaten Transformation due to the tool
tool_length = 0.210;
trafo_tool = eye(4);
trafo_tool(3,4) = tool_length;

for i = 1:10:size(const_stiff,1)
    const_stiff_eef(1,:) = [const_stiff.testcart_pose_loop_out_portMX_x(i) const_stiff.testcart_pose_loop_out_portMY_x(i) const_stiff.testcart_pose_loop_out_portMZ_x(i) const_stiff.testcart_pose_loop_out_portpX(i)];
    const_stiff_eef(2,:) = [const_stiff.testcart_pose_loop_out_portMX_y(i) const_stiff.testcart_pose_loop_out_portMY_y(i) const_stiff.testcart_pose_loop_out_portMZ_y(i) const_stiff.testcart_pose_loop_out_portpY(i)];
    const_stiff_eef(3,:) = [const_stiff.testcart_pose_loop_out_portMX_z(i) const_stiff.testcart_pose_loop_out_portMY_z(i) const_stiff.testcart_pose_loop_out_portMZ_z(i) const_stiff.testcart_pose_loop_out_portpZ(i)];
    const_stiff_eef(4,:) = [0 0 0 1];
    
    const_stiff_cur_loc = const_stiff_eef * trafo_tool;
    const_stiff_cur_pos(i,:) = const_stiff_cur_loc(1:3,4)';
end
for i = 1:1:size(ft,1)
    ft_eef(1,:) = [ft.testcart_pose_loop_out_portMX_x(i) ft.testcart_pose_loop_out_portMY_x(i) ft.testcart_pose_loop_out_portMZ_x(i) ft.testcart_pose_loop_out_portpX(i)];
    ft_eef(2,:) = [ft.testcart_pose_loop_out_portMX_y(i) ft.testcart_pose_loop_out_portMY_y(i) ft.testcart_pose_loop_out_portMZ_y(i) ft.testcart_pose_loop_out_portpY(i)];
    ft_eef(3,:) = [ft.testcart_pose_loop_out_portMX_z(i) ft.testcart_pose_loop_out_portMY_z(i) ft.testcart_pose_loop_out_portMZ_z(i) ft.testcart_pose_loop_out_portpZ(i)];
    ft_eef(4,:) = [0 0 0 1];
    
    ft_cur_loc = ft_eef * trafo_tool;
    ft_cur_pos(i,:) = ft_cur_loc(1:3,4)';
end
for i = 1:size(manip,1)
    manip_eef(1,:) = [manip.testcart_pose_loop_out_portMX_x(i) manip.testcart_pose_loop_out_portMY_x(i) manip.testcart_pose_loop_out_portMZ_x(i) manip.testcart_pose_loop_out_portpX(i)];
    manip_eef(2,:) = [manip.testcart_pose_loop_out_portMX_y(i) manip.testcart_pose_loop_out_portMY_y(i) manip.testcart_pose_loop_out_portMZ_y(i) manip.testcart_pose_loop_out_portpY(i)];
    manip_eef(3,:) = [manip.testcart_pose_loop_out_portMX_z(i) manip.testcart_pose_loop_out_portMY_y(i) manip.testcart_pose_loop_out_portMZ_z(i) manip.testcart_pose_loop_out_portpZ(i)];
    manip_eef(4,:) = [0 0 0 1];
    
    manip_cur_loc = manip_eef * trafo_tool;
    manip_cur_pos(i,:) = manip_cur_loc(1:3,4)';
end
for i = 1:100:size(manip_xyz,1)
    manip_xyz_eef(1,:) = [manip_xyz.testcart_pose_loop_out_portMX_x(i) manip_xyz.testcart_pose_loop_out_portMY_x(i) manip_xyz.testcart_pose_loop_out_portMZ_x(i) manip_xyz.testcart_pose_loop_out_portpX(i)];
    manip_xyz_eef(2,:) = [manip_xyz.testcart_pose_loop_out_portMX_y(i) manip_xyz.testcart_pose_loop_out_portMY_y(i) manip_xyz.testcart_pose_loop_out_portMZ_y(i) manip_xyz.testcart_pose_loop_out_portpY(i)];
    manip_xyz_eef(3,:) = [manip_xyz.testcart_pose_loop_out_portMX_z(i) manip_xyz.testcart_pose_loop_out_portMY_z(i) manip_xyz.testcart_pose_loop_out_portMZ_z(i) manip_xyz.testcart_pose_loop_out_portpZ(i)];
    manip_xyz_eef(4,:) = [0 0 0 1];
    
    manip_xyz_cur_loc = manip_xyz_eef * trafo_tool;
    manip_xyz_cur_pos(i,:) = manip_xyz_cur_loc(1:3,4)';
end
figure;
scatter3(const_stiff_cur_pos(:,1)',const_stiff_cur_pos(:,2)',const_stiff_cur_pos(:,3)','.','MarkerFaceColor',[1 1 0]);
hold on;
scatter3(ft_cur_pos(:,1)',ft_cur_pos(:,2)',ft_cur_pos(:,3)','.','MarkerFaceColor',[1 0 0]);
hold on;
plot3(manip_cur_pos(:,1)',manip_cur_pos(:,2)',manip_cur_pos(:,3)','.','MarkerFaceColor',[0 1 0]);
hold on;
scatter3(manip_xyz_cur_pos(:,1)',manip_xyz_cur_pos(:,2)',manip_xyz_cur_pos(:,3)','.','MarkerFaceColor',[0 0 1]);
legend('constStiff','ft','manip','manipXYZ');