function [s, robot] = initRobot(port)
	
	% Code for Octave/MATLAB compatibility

	format bank
	
	octave = isOctave();
	if(~octave)
		delete(instrfindall);
	else
		pkg load instrument-control
	endif
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	s = serial(port, 115200);
	fopen(s);

	theta0 = 180;
	theta1 = 0;
	x = -160;
	y = 0;
	
	robot = [theta0, theta1, x, y];
end