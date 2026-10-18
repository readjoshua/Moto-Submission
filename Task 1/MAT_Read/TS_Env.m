% empty arrays to store data later
trqData = [];
rpmData = [];

% using the loop to easily iterate for each .tdms file
for i = [1750, 2750, 3250, 3750, 4250, 4750, 5250]
    filename = "torqueData\" + sprintf('torque-speed-%dRPM.tdms', i);
    data = tdmsread(filename);  % tdmsread() requires data acquisition toolbox
    [trq, rpm] = getData(data);
    trqData(end+1) = trq;
    rpmData(end+1) = rpm;
end

% this will pull the max torque for each rpm
function [maxTrq, matchingRpm] = getData(data)
    data = data{1};
    rpm = data.EV_Measured_Speed;
    trq = data.("FMI 1");

    [maxTrq, index] = max(trq);
    matchingRpm = rpm(index);
end

figure;
plot(rpmData, trqData, '-o', 'LineWidth', 1)

% add in the constant torque region as clarified by email. this region is
% in red
hold on;
trqPoints = [trqData(1), trqData(1)];
rpmPoints = [0, rpmData(1)];
plot(rpmPoints, trqPoints, '-o', 'LineWidth', 1)

grid on;
xlabel("Motor Speed (RPM)");
ylabel("Torque (Nm)");
legend("Constant Power", "Constant Torque")

% characterise regions
disp("Constant Torque of ~158Nm from 0 to ~1750rpm")
dTrq = trqData(7) - trqData(1);
dRpm = 5250 - 1750;
grad = dTrq / dRpm;
rpmConstPwr = 4000;    % replace with rpm from 1750-5250. function below should give estimate of trq based on linear relation
trqConstPwr = grad * rpmConstPwr + 185;
disp("Simplified linear relationship between Torque and RPM in the constant Power region is: T = (-0.0206 x RPM) + 185")
