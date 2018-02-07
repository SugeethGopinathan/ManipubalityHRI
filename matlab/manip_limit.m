%% Getting rid of the NAN values at the starting and ending of the Matrix
A= calib;
A(1,:)= [];
A(length(A),:)= [];

%% Plot the Manip
figure
plot(A(:,1), A(:,2));

%% HistFit

figure

hold on
yyaxis left
histdata = hist(A(:,2),200,'normal',1);
histfit(A(:,2),200,'normal')

max(histdata)/100

fit_data = fitdist(A(:,2),'normal');

m_Uplimit  = norminv(.98, fit_data.mu, fit_data.sigma)

xlabel('Manipulability')
ylabel('Frequency')

yyaxis right

ylabel('Stiffness [N/m]')
m_lowLimit = 0.0212;
plot(m_Uplimit,5000,'xg');
plot(m_lowLimit,10,'xg');
plot([0.01,0.0212,m_Uplimit,0.045],[10,10,5000,5000])
ylim([0,7000])