class Particle
{
	PVector location;
	PVector velocity;
	PVector acceleration;
	float mass;
	color c;

	float _x, _y, _z;

	Particle(float m, float x, float y, float z, color $c)
	{
		mass = m;
		c = $c;
		_x = x;
		_y = y;
		_z = z;
		location = new PVector(x, y, z);
		velocity = new PVector(0, 0, 0);
		acceleration = new PVector(0, 0, 0);
	}

	void applyForce(PVector force)
	{
		PVector f = PVector.div(force, mass);
		acceleration.add(f);
	}

	void update()
	{
		velocity.add(acceleration);
		location.add(velocity);
		acceleration.mult(0);
	}

	void display()
	{
		pushMatrix();

			translate(location.x, location.y, location.z);
			
			tint(c);
			imageMode(CENTER);
			image(particle_orb, 0, 0, mass, mass);
			// tint(c, 155);
			// image(noise, 0, 0, mass, mass);
			noTint();

			// ellipseMode(CENTER);
			// noStroke();
			// fill(c, 100);
			// ellipse(0, 0, mass, mass);

		popMatrix();
	}

	void reset()
	{
		location = new PVector(_x, _y, _z);
		velocity = new PVector(0, 0, 0);
		acceleration = new PVector(0, 0, 0);
	}

	PVector repel(Particle p)
	{
		PVector force = PVector.sub(location, p.location);
		float distance = force.mag();
		distance = constrain(distance, 1.0, 10000.0);
		force.normalize();

		float strength = (gravity * mass * p.mass) / (distance * distance);
		force.mult(-1*strength);
		return force;
	}

	void checkEdges()
	{
		if(location.x > width) {
			location.x = width;
			velocity.x *= -1;
		}

		else if(location.x < 0) {
			location.x = 0;
			velocity.x *= -1;
		}

		if(location.y > height) {
			location.y = height;
			velocity.y *= -1;
		}
		else if(location.y < 0) {
			location.y = 0;
			velocity.y *= -1;
		}
	}

}