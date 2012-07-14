class Attractor
{

	float mass;
	PVector location;

	Attractor(float $x, float $y)
	{
		location = new PVector($x, $y);
		mass = 200;
	}

	PVector attract(Particle p)
	{
		PVector force = PVector.sub(location, p.location);
		float d = force.mag();
		// d = constrain(d, 5.0, 25.0);
		d = constrain(d, 1.0, 25.0);
		force.normalize();
		float strength = (gravity * mass * p.mass) / (d * d);
		force.mult(strength);
		return force;
	}

	void display()
	{
		ellipseMode(CENTER);
		noStroke();
		fill(255, 0);
		ellipse(location.x, location.y, mass, mass);
	}

}