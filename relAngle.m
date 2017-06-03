function newRobot = relAngle(robot, theta0, theta1, omega0 = 10, omega1 = 10, updateflag = True, comm = True)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% robot: the list containing the robot current status and serial address
	% theta0: the relative angle that the first motor will move (in degrees)
	% theta1: the relative angle that the second motor will move (in degrees)
	% omega0: the speed at which the first motor will execute the move (in degrees per second)
	% omega1: the speed at which the first motor will execute the move (in degrees per second)
	% updateflag: if set to False, the function will not update the robot virtual coordinates. Defaults to True.
	% comm: if set to False, the function will only print the command string instead of sending it to the controller board. Defaults to True.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% Code to validate the command before sending it to the controller board.
	% This is to ensure that no dangerous commands are sent to the robot.

	newTheta0 = robot[2] + theta0;
	newTheta1 = robot[3] + theta1;
	newX = 160 + 80*cos(newTheta0) + 80*cos(newTheta0 + newTheta1);
	newY = 80*sin(newTheta0) + 80*sin(newTheta0 + newTheta1);
	newRobot = robot

	validCommand = True;

	if(newTheta0 < 0 || newTheta0 > 180)
		disp('ERROR: Destination angle for first motor out of limits.')
		validCommand = False;
	endif

	if(newTheta1 < -180 || newTheta1 > 180)
		disp('ERROR: Destination angle for second motor out of limits.')
		validCommand = False;
	endif

	if(omega0 < 0 || omega1 < 0)
		disp('ERROR: No negative speed values are allowed.')
		validCommand = False;
	endif

	% Code to check the direction of the movement
	if(validCommand)
		if(theta0 < 0)
			neg0 = 1;
			theta0 = abs(theta0);
		else
			dir0 = 0;

		if(theta1 < 0)
			neg1 = 1;
			theta1 = abs(theta1);
		else
			dir1 = 0;

		% Code to calculate how many steps should the motor make

		steps0 = round(theta0*2048.0/360.0);
		steps1 = round(theta1*2048.0/360.0);

		% Code to calculate how many microseconds should the motor wait between each step

		delay0 = round(175781.25/omega0);
		delay1 = round(175781.25/omega1);

		% Code to update the robot current coordinates

		if(updateflag)
			newRobot = [robot[1], newTheta0, newTheta1, newX, newY];
		endif
		
		% Code to format the command message

		message = 'd' + num2str(dir0) + 's' + num2str(steps0) + 't' + num2str(delay0) + 'd' + num2str(dir1) + 's' + num2str(steps1) + 't' + num2str(delay1);

		% Code to send the message

		if(comm)
			if(isOctave())
				srl_write(robot[1], message);
			else
				fprintf(robot[1], message)
		else
			disp(message)
			
		endif

		% Code to wait for the controller board response

		begin = time();
		data = srl_read(robot[1], 1);

		while(data ~= '\n' || time() - begin < 20)
			data = srl_read(robot[1], 1);
		endwhile
	endif
end