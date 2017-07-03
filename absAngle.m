function newRobot = absAngle(serial, robot, theta0, theta1, omega0, omega1)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% serial: serial port that connects to the robot
	% robot: the list containing the robot current status
	% theta0: the absolute angle to which the first motor will move (in degrees)
	% theta1: the absolute angle to which the second motor will move (in degrees)
	% omega0: the speed at which the first motor will execute the move (in degrees per second)
	% omega1: the speed at which the first motor will execute the move (in degrees per second)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	relTheta0 = theta0 - robot(1);
	relTheta1 = theta1 - robot(2);
	
	newRobot = relAngle(serial, robot, relTheta0, relTheta1, omega0, omega1, :);

end