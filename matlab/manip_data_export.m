%% Getting rid of the NAN values at the starting and ending of the Matrix
A= manip;
A(1,:)= [];
A(length(A),:)= [];

%% Plot the Manip
figure
plot(A(:,1), A(:,2));

%% HistFit


histdata = hist(A(:,2),200,'normal',1);

max(histdata)/100

fit_data = fitdist(A(:,2),'normal');

m_Uplimit  = norminv(.98, fit_data.mu, fit_data.sigma)

m_Lowlimit = norminv(.98, -fit_data.mu, fit_data.sigma)