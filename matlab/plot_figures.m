%% Plot Data %

subplot(3,2,1)
boxplot(time, 'Labels',{'Const','Manip','XYZ'})
title("Time of Completion")

subplot(3,2,2)
boxplot(smooth, 'Labels',{'Const','Manip','XYZ'})
title("Smoothness")


subplot(3,2,3)
boxplot(force, 'Labels',{'Const','Manip','XYZ'})
title("Interaction Force")

subplot(3,2,4)
boxplot(force_smooth, 'Labels',{'Const','Manip','XYZ'})
title("Force Smoothness")


positionVector = [0.3, 0.1, 0.3, 0.2];
subplot('Position',positionVector)
boxplot(arc_length, 'Labels',{'Const','Manip','XYZ'})
title("Accuracy measure")