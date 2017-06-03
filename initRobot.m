function [s, theta0, theta1, x, y] = initRobot(port)
	octave = isOctave();
	if(~octave)
		delete(instrfindall);
	else
		pkg load instrument-control
	endif
	
	s = serial(port, 115200);

	fopen(s);
	theta0 = 0;
	theta1 = 0;
	x = 0;
	y = 0;
end