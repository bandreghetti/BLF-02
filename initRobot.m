function [s, robot] = initRobot(port)
	
	% Code for Octave/MATLAB compatibility

	octave = isOctave();
	if(~octave)
		delete(instrfindall);
	else
		pkg load instrument-control
	endif
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	s = serial(port, 115200);
	fopen(s);

	theta0 = 0;
	theta1 = 0;
	x = 320;
	y = 0;
	
	robot = [theta0, theta1, x, y];
end