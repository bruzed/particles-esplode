import org.json.*;
import processing.opengl.*;
import javax.media.opengl.*;

int PARTICLE_SIZE = 100;

float gravity = 1;

ArrayList _images;
PFont _myFont;
PImage a;

int[][] aPixels;
int[][] rValues;
int[][] gValues;
int[][] bValues;

GL gl;
PGraphicsOpenGL pgl;

ArrayList _particles;
Attractor attractor;
PImage particle_orb, noise;
float cameraRotation;

boolean isCameraRotation = true;
boolean isBgColorChange = true;

color bg_color;
ArrayList bg_color_array;

/**
 * Setup
 */
void setup()
{
	size(1280, 720, OPENGL);
	background(0);

	pgl = (PGraphicsOpenGL) g;
	gl = pgl.gl;

	particle_orb = loadImage("white_orb.png");
	noise = loadImage("noise.png");

	_images = new ArrayList();
	_myFont = loadFont("wendy-18.vlw");
	_particles = new ArrayList();
	bg_color_array = new ArrayList();

	attractor = new Attractor(width/2, height/2);

	processImage();
	generateParticles();
}

/**
 * Process the image pixels
 * @return {void}
 */
void processImage()
{
	a = loadImage("degeneration.jpg");
	aPixels = new int[a.width][a.height];
	rValues = new int[a.width][a.height];
	gValues = new int[a.width][a.height];
	bValues = new int[a.width][a.height];
	a.loadPixels();
	for(int i = 0; i < a.height; i++) {
		for(int j = 0; j < a.width; j++) {
			aPixels[j][i] = a.pixels[i*a.width + j];
			rValues[j][i] = int(red(aPixels[j][i]));
			gValues[j][i] = int(green(aPixels[j][i]));
			bValues[j][i] = int(blue(aPixels[j][i]));
		}
	}
}

void generateParticles()
{
	_particles.clear();
	int counter = 0;
	
	for(int i = 0; i < a.height; i += 20) {
		for(int j = 0; j < a.width; j += 20) {
			noStroke();
			// color c = color(rValues[j][i], gValues[j][i], bValues[j][i]);
			color c = color(random(rValues[j][i]), random(gValues[j][i]), random(bValues[j][i]));
			bg_color_array.add(c);
			_particles.add(new Particle(random(PARTICLE_SIZE), random(width), random(height), random(1000), c));
			counter++;
		}
	}
}

void resetParticles()
{
	for(int i = 0; i < _particles.size(); i++) {
		Particle particle = (Particle) _particles.get(i);
		particle.reset();
	}
}

void draw()
{
	if(isBgColorChange) {
		bg_color = (color)(Integer) bg_color_array.get( int( random(bg_color_array.size()) ) );	
	}
	
	background(bg_color);

	pgl.beginGL();
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glEnable(GL.GL_BLEND);
		gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
	pgl.endGL();

	attractor.display();
	
	pushMatrix();
		beginCamera();
		camera();		
		if(isCameraRotation) {
			cameraRotation -= 0.05;
		}
		rotateZ(cameraRotation);
		endCamera();

		for(int i = 0; i < _particles.size(); i++) {
			Particle particle = (Particle) _particles.get(i);
			PVector force = attractor.attract(particle);
			particle.applyForce(force);
			particle.update();
			particle.display();
		}
	popMatrix();

	// fill(255);
	// textFont(_myFont, 18);
	// text(frameRate, 10, 10);
}

void keyPressed()
{
	if(key=='r') {
		attractor.mass = 200;
		resetParticles();
		isCameraRotation = true;
		isBgColorChange = true;
	}
	if(key=='s') {
		attractor.mass = 1;
		isCameraRotation = false;
		isBgColorChange = false;
	}
}