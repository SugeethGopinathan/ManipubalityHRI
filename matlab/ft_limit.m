%% Getting rid of the NAN values at the starting and ending of the Matrix
A= ft;
A(1,:)= [];
A(length(A),:)= [];


%% HistFit

figure
histdata = hist(A,200,'normal',1);
histfit(A,200,'normal')

max(histdata)/100

fit_data = fitdist(A,'normal');

m_Uplimit  = norminv(.98, fit_data.mu, fit_data.sigma)
