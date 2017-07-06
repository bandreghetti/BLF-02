function newRobot = Phase1(serial, robot, x, y, omega0 = 20, omega1 = 20)
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

	if(omega0 < 0 || omega1 < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = false;
	endif
	
	if(sqrt(x^2+y^2) > 160 || sqrt((x+80)^2+y^2) < 80 || sqrt(x^2+y^2) < 40)
		disp('ERROR: Destination point out of robot limits')
		validCommand = false;
	endif
	
	if(validCommand)
		Xafter0 = 80*cosd(theta0f) + 80*cosd(theta0f+theta1i);
		Yafter0 = 80*sind(theta0f) + 80*sind(theta0f+theta1i);

		if(sqrt(Xafter0^2+Yafter0^2) <= 160 && sqrt((Xafter0+80)^2+Yafter0^2) >= 80 && sqrt(Xafter0^2+Yafter0^2) >= 40)
			%move joint 0 first
			newRobot = absAngleSmooth(serial, newRobot, theta0f, newRobot(2), omega0, omega1);
			newRobot = absAngleSmooth(serial, newRobot, newRobot(1), theta1f, omega0, omega1);
		else
			Xafter1 = 80*cosd(theta0i) + 80*cosd(theta0i+theta1f);
			Yafter1 = 80*sind(theta0i) + 80*sind(theta0i+theta1f);

			if(sqrt(Xafter1^2+Yafter1^2) <= 160 && sqrt((Xafter1+80)^2+Yafter1^2) >= 80 && sqrt(Xafter1^2+Yafter1^2) >= 40)			
				%move joint 1 first
				newRobot = absAngleSmooth(serial, newRobot, newRobot(1), theta1f, omega0, omega1);
				newRobot = absAngleSmooth(serial, newRobot, theta0f, newRobot(2), omega0, omega1);
			else
				disp('ERROR: Robot is unable to reach this point using this movement strategy')
			end
		end
	end
	
endfunction