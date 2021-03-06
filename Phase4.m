function newRobot = Phase4(serial, robot, xf, yf)
	[theta0f, theta1f] = calcAngles(xf, yf);
	theta0i = robot(1);
	theta1i = robot(2);
	
	speed = 20;
	omega = 20;
	
	xi = robot(3);
	yi = robot(4);
	
	newRobot = robot;
	
	validCommand = true;
	
	distance = sqrt((xf-xi)^2+(yf-yi)^2);
	
	total_time = distance/omega;
	
	dtime = total_time/20;
	
	t = [0:dtime:total_time];
	
	X = xi + (xf - xi)*t/total_time;
	Y = yi + (yf - yi)*t/total_time;
	
	if(theta0f < 0 || theta0f > 180)
		disp('ERROR: Destination angle for first motor out of limits.')
		validCommand = false;
	endif

	if(theta1f < -180 || theta1f > 180)
		disp('ERROR: Destination angle for second motor out of limits.')
		validCommand = false;
	endif

	if(speed < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = false;
	endif
	
	if(sqrt(xf^2+yf^2) > 160 || sqrt((xf+80)^2+yf^2) < 80 || sqrt(xf^2+yf^2) < 40)
		disp('ERROR: Destination point out of robot limits')
		validCommand = false;
	endif
	
	Distances = sqrt(X.^2+Y.^2);
	
	if(sum(Distances > 160) > 0 || sum(sqrt((X+80).^2+Y.^2) < 80) > 0 || sum(Distances < 40) > 0)
		printf('ERROR: Unable to draw straight line from (%.2f, %.2f) to (%.2f, %.2f)\n', xi, yi, xf, yf)
		validCommand = false;
	endif
	
	for i = [1:length(X)]
		[theta0f, theta1f] = calcAngles(X(i), Y(i));
		theta0i = newRobot(1);
		theta1i = newRobot(2);
		deltatheta0 = abs(theta0f - theta0i);
		deltatheta1 = abs(theta1f - theta1i);
		
		if(validCommand && (deltatheta0 ~= 0 || deltatheta1 ~= 0))	
			if(deltatheta0 < deltatheta1)
				omega1 = omega;
				omega0 = abs((deltatheta0*omega1)/deltatheta1);
			else
				omega0 = omega;
				omega1 = abs((deltatheta1*omega0)/deltatheta0);
			end
			newRobot = absAngle(serial, newRobot, theta0f, theta1f, omega0, omega1);
		end
	endfor
endfunction