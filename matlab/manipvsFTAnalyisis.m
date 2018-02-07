close all
A= reports;
A(1,:)= [];
A(size(A),:)= [];

Force= sqrt(pow2(A.jr3ForceTorqueOutputPortforces0)+pow2(A.jr3ForceTorqueOutputPortforces1)+pow2(A.jr3ForceTorqueOutputPortforces2));

[B,Aa] = butter(3,.05);


filt_force = filter(B,Aa, Force);

filt_FT = filter(B,Aa,A.manipforce_transmission_out_port);

filt_manip = filter(B,Aa, A.manipmanip_measure_out_port);
figure;

plotyy(A.TimeStamp,filt_manip,A.TimeStamp,filt_FT)
title("manip vs FT")
legend('manip','FT')
figure;
plotyy(A.TimeStamp,filt_force,A.TimeStamp,filt_FT)
title("Force vs FT")
legend('Force','FT')



figure
histdata = hist(filt_force,200,'rayleigh',1);
histfit(filt_force,200,'rayleigh')

max(histdata)/100

fit_data = fitdist(A(:,2),'normal');

m_Uplimit  = norminv(.98, fit_data.mu, fit_data.sigma)
