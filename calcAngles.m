function [theta0, theta1] = calcAngles(x, y)

	l1 = 80;
	l2 = 80;
	
	theta1 = -acosd((x^2+y^2-l1^2-l2^2)/(2*l1*l2));
	theta0 = atan2d((y*(l1+l2*cosd(theta2))-x*l2*sind(theta2)), (x*(l1+l2*cosd(theta2))+y*l2*sind(theta2)));

	%theta2 = acosd((x^2+y^2-l1^2-l2^2)/(2*l1*l2));
	%theta1 = atand((y*(l1+l2*cosd(theta2))-x*l2*sind(theta2))/(x*(l1+l2*cosd(theta2))+y*l2*sind(theta2)));
	
	theta0
	theta1
	
	x = (l1*cosd(theta0) + l2*cosd(theta0+theta1))
	y = l1*sind(theta0) + l2*sind(theta0+theta1)

	X = [l1*cosd(theta0); x];
	Y = [l1*sind(theta0); y];
	
	plot(X, Y, 'o')
	axis([-160, +160, -160, 160])
	
endfunction