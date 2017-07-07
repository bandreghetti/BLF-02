function newRobot = Phase3(serial, robot, x, y, maxomega = 20)
	[theta0f, theta1f] = calcAngles(x, y);
	theta0i = robot(1);
	theta1i = robot(2);
	
	newRobot = robot;
	
	validCommand = true;

	if(theta0f < 0 || theta0f > 180)
		disp('ERROR: Destination angle for first motor out of limits.')
		validCommand = false;
	endif

	if(theta1f < -180 || theta1f > 180)
		disp('ERROR: Destination angle for second motor out of limits.')
		validCommand = false;
	endif

	if(maxomega < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = false;
	endif
	
	if(sqrt(x^2+y^2) > 160 || sqrt((x+80)^2+y^2) < 80 || sqrt(x^2+y^2) < 40)
		disp('ERROR: Destination point out of robot limits')
		validCommand = false;
	endif
	
	deltatheta0 = abs(theta0f - theta0i);
	deltatheta1 = abs(theta1f - theta1i);
	
	if(validCommand && (deltatheta0 ~= 0 || deltatheta1 ~= 0))	
		if(deltatheta0 < deltatheta1)
			omega1 = maxomega;
			omega0 = abs((deltatheta0*omega1)/deltatheta1);
		else
			omega0 = maxomega;
			omega1 = abs((deltatheta1*omega0)/deltatheta0);
		end
		newRobot = absAngleSmooth(serial, newRobot, theta0f, theta1f, omega0, omega1);
	end
	
endfunction