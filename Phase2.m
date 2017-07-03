function newRobot = Phase2(serial, robot, x, y, omega = 15)
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

	if(omega < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = false;
	endif
	
	if(sqrt(x^2+y^2) > 160 || sqrt((x+80)^2+y^2) < 80 || sqrt(x^2+y^2) < 40)
		disp('ERROR: Destination point out of robot limits')
		validCommand = false;
	endif
	
	if(validCommand)
		newRobot = absAngleSmooth(serial, newRobot, theta0f, theta1f, omega, omega);
	end
	
endfunction