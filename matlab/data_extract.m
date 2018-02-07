close all
clear
load('/home/sgo/Desktop/HRI_data/Matlab/user4/user4.mat')
%% Extracting the data
XYZ(:,1) = xyz.testcart_pose_loop_out_portpX;
XYZ(:,2) = xyz.testcart_pose_loop_out_portpY;
XYZ(:,3) = xyz.testcart_pose_loop_out_portpZ;

XYZ(any(isnan(XYZ),2),:) = [];

MAN(:,1) = manip.testcart_pose_loop_out_portpX;
MAN(:,2) = manip.testcart_pose_loop_out_portpY;
MAN(:,3) = manip.testcart_pose_loop_out_portpZ;
MAN(any(isnan(MAN),2),:) = [];

CONST(:,1) = stiff.testcart_pose_loop_out_portpX;
CONST(:,2) = stiff.testcart_pose_loop_out_portpY;
CONST(:,3) = stiff.testcart_pose_loop_out_portpZ;

CONST(any(isnan(CONST),2),:) = [];

%% Finding the number of peaks


peaks_xyz = size(findpeaks(XYZ(:,1)),1)+size(findpeaks(XYZ(:,2)),1)+size(findpeaks(XYZ(:,3)),1)
peaks_manip = size(findpeaks(MAN(:,1)),1)+size(findpeaks(MAN(:,2)),1)+size(findpeaks(MAN(:,3)),1)
peaks_const = size(findpeaks(CONST(:,1)),1)+size(findpeaks(CONST(:,2)),1)+size(findpeaks(CONST(:,3)),1)

peaks = 'Smoothness measure (Peaks) for %s is %8.3f \n';

fprintf(peaks,'Const',mean(peaks_const));
fprintf(peaks,'Manip',mean(peaks_manip));
fprintf(peaks,'XYZ',mean(peaks_xyz));
%% Force average
Force_manip= [manip.jr3ForceTorqueOutputPortforces0,manip.jr3ForceTorqueOutputPortforces1,manip.jr3ForceTorqueOutputPortforces2];
Force_manip(any(isnan(Force_manip),2),:) = [];

Force_const= [stiff.jr3ForceTorqueOutputPortforces0,stiff.jr3ForceTorqueOutputPortforces1,stiff.jr3ForceTorqueOutputPortforces2];
Force_const(any(isnan(Force_const),2),:) = [];


Force_xyz= [xyz.jr3ForceTorqueOutputPortforces0,xyz.jr3ForceTorqueOutputPortforces1,xyz.jr3ForceTorqueOutputPortforces2];
Force_xyz(any(isnan(Force_xyz),2),:) = [];


r_f_m = sqrt( Force_manip(:,1).*Force_manip(:,1) +  Force_manip(:,2).*Force_manip(:,2)  + Force_manip(:,3).*Force_manip(:,3));

r_f_c = sqrt( Force_const(:,1).*Force_const(:,1) +  Force_const(:,2).*Force_const(:,2)  + Force_const(:,3).*Force_const(:,3));

r_f_xyz = sqrt( Force_xyz(:,1).*Force_xyz(:,1) +  Force_xyz(:,2).*Force_xyz(:,2)  + Force_xyz(:,3).*Force_xyz(:,3));


%% Filter using Butterworth

[B,A] = butter(3,.0001);


filt_f_m = filter(B,A, r_f_m);

filt_f_c = filter(B,A, r_f_c);

filt_f_xyz = filter(B,A, r_f_xyz);

mean_force = 'Mean Force for %s is %8.3f N\n';


mean(filt_f_m);
mean(filt_f_c);
mean(filt_f_xyz);

fprintf(mean_force,'Const',mean(filt_f_c));
fprintf(mean_force,'Manip',mean(filt_f_m));
fprintf(mean_force,'XYZ',mean(filt_f_xyz));

peak_force = 'Force smoothness measure for %s is %8.3f \n';

size(findpeaks(filt_f_c),1);
size(findpeaks(filt_f_m),1);
size(findpeaks(filt_f_xyz),1);


fprintf(peak_force,'Const',size(findpeaks(filt_f_c),1));
fprintf(peak_force,'Manip',size(findpeaks(filt_f_m),1));
fprintf(peak_force,'XYZ',size(findpeaks(filt_f_xyz),1));

time = 'Time of completion for %s is %8.3f seconds\n';

fprintf(time,'Const',stiff.TimeStamp((size(stiff.TimeStamp,1)-1)));
fprintf(time,'Manip',manip.TimeStamp((size(manip.TimeStamp,1)-1)));
fprintf(time,'XYZ',xyz.TimeStamp((size(xyz.TimeStamp,1)-1)));


%% Arc Length

ARC_M(1) = 0;
for i = 1:1:((size(MAN,1))-1)
    s_m(i) = sqrt( (MAN(i+1,1)-MAN(i,1))*(MAN(i+1,1)-MAN(i,1)) +(MAN(i+1,2)-MAN(i,2))*(MAN(i+1,2)-MAN(i,2)));
    ARC_M(i+1) = ARC_M(i)+s_m(i);
    
end

ARC_C(1) = 0;
for i = 1:1:((size(CONST,1))-1)
    s_c(i) = sqrt( (CONST(i+1,1)-CONST(i,1))*(CONST(i+1,1)-CONST(i,1)) +(CONST(i+1,2)-CONST(i,2))*(CONST(i+1,2)-CONST(i,2)));
    ARC_C(i+1) = ARC_C(i)+s_c(i);
    
end

ARC_XYZ(1) = 0;
for i = 1:1:((size(XYZ,1))-1)
    s_xyz(i) = sqrt( (XYZ(i+1,1)-XYZ(i,1))*(XYZ(i+1,1)-XYZ(i,1)) +(XYZ(i+1,2)-XYZ(i,2))*(XYZ(i+1,2)-XYZ(i,2)));
    ARC_XYZ(i+1) = ARC_XYZ(i)+s_xyz(i);
    
end


arc_length = 'Arc Length for %s is %8.3f m\n';

fprintf(arc_length,'Const', max(ARC_C));
fprintf(arc_length,'Manip', max(ARC_M));
fprintf(arc_length,'XYZ', max(ARC_XYZ));

%% Plotting Manip Measures

%setting filter
clf; close all

[B,A] = butter(3,.0004);



manip_const = stiff.manipmanip_measure_out_port;
manip_manip = manip.manipmanip_measure_out_port;
manip_xyz = xyz.manipmanip_measure_out_port;
manip_const(any(isnan(manip_const),2),:) = [];
manip_manip(any(isnan(manip_manip),2),:) = [];
manip_xyz(any(isnan(manip_xyz),2),:) = [];


filt_manip_const = filter(B,A, manip_const);

figure
plot(manip_const)
hold on
plot(filt_manip_const)

filt_manip_xyz = filter(B,A, manip_xyz);
figure
plot(manip_xyz)
plot(filt_manip_xyz)

filt_manip_manip = filter(B,A, manip_manip);
figure
plot(manip_manip)
plot(filt_manip_manip)



%% Plotting Trajecotries%%
%figure
%plot3(XYZ(:,1) ,XYZ(:,2) ,XYZ(:,3))
%figure
%plot3(MAN(:,1) ,MAN(:,2) ,MAN(:,3))
%figure
%plot3(CONST(:,1) ,CONST(:,2) ,CONST(:,3))


%% Plotting Manip vs Force
figure
hold on
yyaxis left
plot(ARC_M,filt_manip_manip,'-r')
plot(ARC_C,filt_manip_const,'-b')
plot(ARC_XYZ,filt_manip_xyz,'-k')
 
yyaxis right
plot(ARC_M,filt_f_m,'-r')
plot(ARC_C,filt_f_c,'-b')
plot(ARC_XYZ,filt_f_xyz,'k')
ylim([0 15])
xlim([0 1.2])

legend('Manip','Const','XYZ')
title("Manipulability vs Force")
grid on


%% Plotting XYZ Manip vs XYZ Force
