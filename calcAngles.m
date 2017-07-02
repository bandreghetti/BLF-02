function [theta0, theta1] = calcAngles(x, y)

	l1 = 80;
	l2 = 80;
	
	theta1 = -acosd((x^2+y^2-l1^2-l2^2)/(2*l1*l2));
	theta0 = atan2d((y*(l1+l2*cosd(theta1))-x*l2*sind(theta1)), (x*(l1+l2*cosd(theta1))+y*l2*sind(theta1)));

	%theta2 = acosd((x^2+y^2-l1^2-l2^2)/(2*l1*l2));
	%theta1 = atand((y*(l1+l2*cosd(theta1))-x*l2*sind(theta1))/(x*(l1+l2*cosd(theta1))+y*l2*sind(theta1)));
	
	theta0;
	theta1;
	
	x = (l1*cosd(theta0) + l2*cosd(theta0+theta1));
	y = l1*sind(theta0) + l2*sind(theta0+theta1);

	X = [0; l1*cosd(theta0); x];
	Y = [0; l1*sind(theta0); y];
	
	% Plot the work area
	
	t0 = [0:1:180];
	t1 = [-180:1:0];
	
	c1x = 80*cosd(t1+180)-80;
	c1y = 80*sind(t1+180);
	c2x = 160*cosd(t0);
	c2y = 160*sind(t0);
	c3x = 40*cosd(t0);
	c3y = 40*sind(t0);
	c4x = [-160:160];
	c4y = 0;
	
	%plot(c1x, c1y, 'k', c2x, c2y, 'k', c3x, c3y, 'k', c4x, c4y, 'k', X, Y, )
	%axis([-160, +160, -160, 160])
	
endfunction