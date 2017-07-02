function newRobot = relAngle(serial, robot, theta0, theta1, omega0 = 10, omega1 = 10, comm = true)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% serial: serial port that connects to the robot
	% robot: the list containing the robot current status
	% theta0: the relative angle that the first motor will move (in degrees)
	% theta1: the relative angle that the second motor will move (in degrees)
	% omega0: the speed at which the first motor will execute the move (in degrees per second)
	% omega1: the speed at which the first motor will execute the move (in degrees per second)
	% comm: if set to False, the function will only print the command string instead of sending it to the controller board. Defaults to True.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Code to validate the command before sending it to the controller board.
	% This is to ensure that no dangerous commands are sent to the robot.

	newTheta0 = robot(1) + theta0;
	newTheta1 = robot(2) + theta1;
	newX = 80*cos(newTheta0) + 80*cos(newTheta0 + newTheta1);
	newY = 80*sin(newTheta0) + 80*sin(newTheta0 + newTheta1);

	validCommand = true;

	if(newTheta0 < 0 || newTheta0 > 180)
		disp('ERROR: Destination angle for first motor out of limits.')
		validCommand = false;
	endif

	if(newTheta1 < -180 || newTheta1 > 180)
		disp('ERROR: Destination angle for second motor out of limits.')
		validCommand = false;
	endif

	if(omega0 < 0 || omega1 < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = false;
	endif

	% Code to check the direction of the movement
	if(validCommand)
		if(theta0 < 0)
			dir0 = 0;
			theta0 = abs(theta0);
		else
			dir0 = 1;
		endif

		if(theta1 < 0)
			dir1 = 1;
			theta1 = abs(theta1);
		else
			dir1 = 0;
		endif

		% Code to calculate how many steps should the motor make

		steps0 = round(theta0*2048.0/360.0);
		steps1 = round(theta1*2048.0/360.0);

		% Code to calculate how many microseconds should the motor wait between each step

		if(omega0 ~= 0)
			delay0 = round(175781.25/omega0);
		else
			delay0 = 0;
		endif
		
		if(omega1 ~= 0)
			delay1 = round(175781.25/omega1);
		else
			delay1 = 0;
		endif

		% Code to update the robot current coordinates

		newRobot = [newTheta0, newTheta1, newX, newY];
		
		% Code to format the command message

		message = strcat(num2str(dir0, '%01d'), num2str(steps0, '%04d'), num2str(delay0, '%06d'), num2str(dir1, '%01d'), num2str(steps1, '%04d'), num2str(delay1, '%06d'));

		% Code to send the message

		if(comm)
			if(isOctave())
				srl_write(serial, message);
			else
				fprintf(serial, message)
			endif

			% Code to wait for the controller board response

			begin = time();
			data = srl_read(serial, 1);

			while(data ~= 'z' || time() - begin < 20)
				data = srl_read(serial, 1);
			endwhile
		else
			disp(message)
		endif
	endif
endfunction
