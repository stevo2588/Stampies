//  multitouch_shapeRecognition.pde
//    Original Code by Stephen Aldriedge, 2013
//    Modified by Emily Harris

int windowWidth = 965;
int windowHeight = 720;

float pi = 3.14159;

float angles1[18];
float angles2[15];
float angles3[12];
float angles4[10];

float shapeColor[3];

float angle1 = 0;
float angle2 = 0;
float angle3 = 0;
float angle4 = 0;
float angle_increment = .01;
float angle_increment2 = .015;

ofxVec2f center1;
center1.set(-900, -900);
ofxVec2f center2;
center2.set(-900, -900);

float[] color1 = new float[0, 0, 0];
float[] color2 = new float[0, 0, 0];

float opacity;

String debugmsg = "";
PFont f;
ArrayList tShapes;
ArrayList unassigned; // ArrayList to hold unassigned touches

// FOR DEBUGGING PURPOSES: If you need to run this on your computer to check for errors and
// such, uncomment the DEBUG code below. Make sure to leave it commented when you are running
// the code on a mobile device.
/*
//------------------ DEBUG BEGIN -------------------------------------------------------------
class Touch {
	Touch(int x, int y) {
		offsetX = x;
		offsetY = y;
	}

	int offsetX, offsetY;
}
class TouchEvent {
	TouchEvent(Touch[] t) {
		touches = t;
		changedTouches = t;
	}

	Touch[] touches;
	Touch[] changedTouches;
}

TouchEvent te;

void touchSimulateSetup() {
	Touch[] simTouchPts = new Touch[3];
	simTouchPts[0] = new Touch(43, 88);
	simTouchPts[1] = new Touch(90, 142);
	simTouchPts[2] = new Touch(168, 70);
	te = new TouchEvent(simTouchPts);
}

void mousePressed() {
	touchSimulateSetup();
	touchStart(te);
}
void mouseDragged() {
	te.touches[0] = new Touch(mouseX+te.touches[0].offsetX, mouseY+te.touches[0].offsetY);
	te.touches[1] = new Touch(mouseX+te.touches[1].offsetX, mouseY+te.touches[1].offsetY);
	te.touches[2] = new Touch(mouseX+te.touches[2].offsetX, mouseY+te.touches[2].offsetY);
	te.changedTouches = te.touches;
	touchMove(te);
}
//----------------- DEBUG END ----------------------------------------------------------------
*/

//----------------- SETUP ----------------------------------
void setup() {
  size( windowWidth , windowHeight); 

  background( 0 );
  f = createFont("Arial",16,true);

  smooth();
  tShapes = new ArrayList();
  unassigned = new ArrayList();

  //-------------- Create shapes to use -----------------------
  PVector[] shVerts01 = new PVector[3];
        shVerts01[0] = new PVector(5, -108);
        shVerts01[1] = new PVector(118, -19);
        shVerts01[2] = new PVector(-122, 129);  
//        shVerts01[0] = new PVector(-3, -94);
//        shVerts01[1] = new PVector(130, 27);
//        shVerts01[2] = new PVector(-126, 67);

  PVector[] shVerts02 = new PVector[3];
        shVerts02[0] = new PVector(-12, 126);
        shVerts02[1] = new PVector(-122, -70);
        shVerts02[2] = new PVector(135, -56);  
//        shVerts02[0] = new PVector(102, -77);
//        shVerts02[1] = new PVector(-14, 98);
//        shVerts02[2] = new PVector(-86, -20);

  //--------------- Register shapes --------------------------
  registerShape(new MyObject(new Shape(shVerts01), 15, "bassDrum"));

        for (int i = 0; i < 18; i++){
           angles1[i] = angle1;
           angle1 += (PI/9); 
        }
        for (int i = 0; i < 15; i++){
           angles2[i] = angle2;
           angle2 += (PI/7.5); 
        }
        for (int i = 0; i < 12; i++){
           angles3[i] = angle3;
           angle3 += (PI/6); 
        }
        for (int i = 0; i < 10; i++){
           angles4[i] = angle4;
           angle4 += (PI/5); 
        } 
  registerShape(new MyObject(new Shape(shVerts02), 15, "otherSound"));

        for (int i = 0; i < 18; i++){
           angles1[i] = angle1;
           angle1 += (PI/9); 
        }
        for (int i = 0; i < 15; i++){
           angles2[i] = angle2;
           angle2 += (PI/7.5); 
        }
        for (int i = 0; i < 12; i++){
           angles3[i] = angle3;
           angle3 += (PI/6); 
        }
        for (int i = 0; i < 10; i++){
           angles4[i] = angle4;
           angle4 += (PI/5); 
        }                

}

//--------------- Derive your own class from TouchShape class ------------------
class MyObject extends TouchShape {
	MyObject(Shape s, int tol, String soundString) {
		super(s,tol,soundString);
	}
	// create your own draw method here
	void draw() {
		resetMatrix();
                //bassDrum.play();
                //background(0);
                float diameter = 800*.9;
                float lg_diam =  800 * .7;             // large circle's diameter
                float lg_rad1  = lg_diam/2;             // large circle's radius
                float lg_rad2  = lg_diam/2.32;
                float lg_rad3  = lg_diam/2.75;
                float lg_rad4  = lg_diam/3.2;  
                float lg_circ =  PI * lg_diam;          // large circumference
                float sm_diam1 = (30);  
                float sm_diam2 = (25);      
                float sm_diam3 = (20);      
                float sm_diam4 = (15);

                float mixedColors = new float[3];

                noStroke(); 
                smooth();               
                curColor = chooseColor(rotAngle);

                //println(rotAngle);

                for (int i = 0; i < 18; ++i) {
                  float x = center.x + cos(angles1[i]) * lg_rad1;
                  float y = center.y + sin(angles1[i]) * lg_rad1;                 
                  float distanceToCenter1 = distance(x, y, otherCenter);
                  //println(otherCenter.x + "  " + otherCenter.y);
                  if(distanceToCenter1 <= 600){
                      mixedColors = mixColors(curColor, otherColor, distanceToCenter1);
                      fill (mixedColors[0], mixedColors[1], mixedColors[2]);
                  }

                  else{
                    fill (curColor[0], curColor[1], curColor[2]);
                  }                  
                  ellipse(x, y, sm_diam1, sm_diam1);
                }
                for (int i = 0; i < 15; ++i) {
                  float x = center.x + cos(angles2[i]) * lg_rad2;
                  float y = center.y + sin(angles2[i]) * lg_rad2;
                  float distanceToCenter2 = distance(x, y, otherCenter);
                  if(distanceToCenter2 <= 600){
                      mixedColors = mixColors(curColor, otherColor, distanceToCenter2);
                      fill (mixedColors[0], mixedColors[1], mixedColors[2]);
                  }
                  else{
                    fill (curColor[0], curColor[1], curColor[2]);
                  }                  
                  ellipse(x, y, sm_diam2, sm_diam2);
                }
                for (int i = 0; i < 12; ++i) {
                  float x = center.x + cos(angles3[i]) * lg_rad3;
                  float y = center.y + sin(angles3[i]) * lg_rad3;
                  float distanceToCenter3 = distance(x, y, otherCenter);
                  if(distanceToCenter3 <= 600){
                      mixedColors = mixColors(curColor, otherColor, distanceToCenter3);
                      fill (mixedColors[0], mixedColors[1], mixedColors[2]);
                  }
                  else{
                    fill (curColor[0], curColor[1], curColor[2]);
                  }                 
                  ellipse(x, y, sm_diam3, sm_diam3);
                }  
                for (int i = 0; i < 10; ++i) {
                  float x = center.x + cos(angles4[i]) * lg_rad4;
                  float y = center.y + sin(angles4[i]) * lg_rad4;
                  float distanceToCenter4 = distance(x, y, otherCenter);
                  if(distanceToCenter4 <= 600){
                      mixedColors = mixColors(curColor, otherColor, distanceToCenter4);
                      fill (mixedColors[0], mixedColors[1], mixedColors[2]);
                  }
                  else{
                    fill (curColor[0], curColor[1], curColor[2]);
                  }                  
                  ellipse(x, y, sm_diam4, sm_diam4);
                }

                for (int i = 0; i < 18; i++){
                  angles1[i] += angle_increment;
                } 
                for (int i = 0; i < 15; i++){
                  angles2[i] -= angle_increment;
                } 
                for (int i = 0; i < 12; i++){
                  angles3[i] += angle_increment2;
                } 
                for (int i = 0; i < 10; i++){
                  angles4[i] -= angle_increment2;
                } 

	}
        void drawCenters(){
            resetMatrix();
            noStroke();
            smooth();            
            curColor = chooseColor(rotAngle);

            fill (curColor[0], curColor[1], curColor[2]); 
            ellipse(center.x, center.y, 250, 250);

        }

}

//------------------- DRAW ----------------------------------------
int counter = 0;
void draw() {
	background( 0 );     

	pushMatrix();

	int shSize = tShapes.size();

        for(int i=0; i<shSize; i++){                                              //Draw the centers first
          if(!((TouchShape)tShapes.get(i)).first){
            ((TouchShape)tShapes.get(i)).drawCenters();
          }
        }          

  	for(int i=0; i<shSize; i++) {
              if ((((TouchShape)tShapes.get(i)).beforeFirst) == false){
                  //((TouchShape)tShapes.get(i)).playSound();                                                    //UNCOMMENT FOR SOUND
              }
              if(!((TouchShape)tShapes.get(i)).first) {
                    if (i==0){
                        center1.x =((TouchShape)tShapes.get(i)).center.x;         //Remember the shapes center
                        center1.y =((TouchShape)tShapes.get(i)).center.y; 
                        ((TouchShape)tShapes.get(i)).otherCenter.x = center2.x;
                        ((TouchShape)tShapes.get(i)).otherCenter.y = center2.y;
                        color1 = ((TouchShape)tShapes.get(i)).curColor;
                        ((TouchShape)tShapes.get(i)).otherColor = color2;

			((TouchShape)tShapes.get(i)).draw();                         
                    }
                    if (i==1){
                        center2.x =((TouchShape)tShapes.get(i)).center.x;         //Remember the shapes center
                        center2.y =((TouchShape)tShapes.get(i)).center.y;   
                        ((TouchShape)tShapes.get(i)).otherCenter.x = center1.x;
                        ((TouchShape)tShapes.get(i)).otherCenter.y = center1.y; 
                        color2 = ((TouchShape)tShapes.get(i)).curColor;
                        ((TouchShape)tShapes.get(i)).otherColor = color1;                          

                        ((TouchShape)tShapes.get(i)).draw();
                    }
	    }
        }

	popMatrix();

	textFont(f,36);
	fill(255);
}

// register shapes to use
void registerShape(TouchShape ts) {
	tShapes.add(ts);
}

float distance(float x, float y, PVector otherCenter){
  float distance = 0; 
  distance = sqrt(((x - otherCenter.x) * (x - otherCenter.x)) + ((y - otherCenter.y) * (y - otherCenter.y)));  
  return distance;
}

float[] mixColors(float[] color1, float[] color2, float distance){
    float mixedColors[] = new float[3];
    if (distance <= 300){
      float red = ((color1[0] * .5) + (color2[0] * .5)); 
      float green = ((color1[1] * .5) + (color2[1] * .5)); 
      float blue = ((color1[2] * .5) + (color2[2] * .5));
      mixedColors = [red, green, blue]; 
   }
   else{
     mixedColors = [color1[0], color1[1], color1[2]];
   }
   return mixedColors;  
}
float[] chooseColor(float rotAngle){
    if (rotAngle  0)                         //Red
      shapeColor = [255, 0, 0];

    else if (rotAngle > (pi/24) && rotAngle  ((2*pi)/24) && rotAngle  ((3*pi)/24) && rotAngle  ((4*pi)/24) && rotAngle  ((5*pi)/24) && rotAngle  ((6*pi)/24) && rotAngle  ((7*pi)/24) && rotAngle  ((8*pi)/24) && rotAngle  ((9*pi)/24) && rotAngle  ((10*pi)/24) && rotAngle  ((11*pi)/24) && rotAngle  ((12*pi)/24) && rotAngle  ((13*pi)/24) && rotAngle  ((14*pi)/24) && rotAngle  ((15*pi)/24) && rotAngle  ((16*pi)/24) && rotAngle  ((17*pi)/24) && rotAngle  ((18*pi)/24) && rotAngle  ((19*pi)/24) && rotAngle  ((20*pi)/24) && rotAngle  ((21*pi)/24) && rotAngle  ((22*pi)/24) && rotAngle  ((23*pi)/24) && rotAngle   pi  && rotAngle  ((25*pi)/24) && rotAngle  ((26*pi)/24) && rotAngle  ((27*pi)/24) && rotAngle  ((28*pi)/24) && rotAngle  ((29*pi)/24) && rotAngle  ((30*pi)/24) && rotAngle  ((31*pi)/24) && rotAngle  ((32*pi)/24) && rotAngle  ((33*pi)/24) && rotAngle  ((34*pi)/24) && rotAngle  ((35*pi)/24) && rotAngle  ((36*pi)/24) && rotAngle  ((37*pi)/24) && rotAngle  ((38*pi)/24) && rotAngle  ((39*pi)/24) && rotAngle  ((40*pi)/24) && rotAngle  ((41*pi)/24) && rotAngle  ((42*pi)/24) && rotAngle  ((43*pi)/24) && rotAngle  ((44*pi)/24) && rotAngle  ((45*pi)/24) && rotAngle  ((46*pi)/24) && rotAngle  ((47*pi)/24) && rotAngle  -2.2 && rotAngle  -2.05 && rotAngle  -1.8 && rotAngle  -1.5 && rotAngle  -1.27 && rotAngle  -1.05 && rotAngle  -.85 && rotAngle  -.7 && rotAngle  -.65 && rotAngle  -.49 && rotAngle  -.35 && rotAngle  -.22 && rotAngle  -.1 && rotAngle  -4.3 && rotAngle  -4.0667 && rotAngle  -3.936 && rotAngle  -3.8067 && rotAngle  -3.6767 && rotAngle  -3.5467 && rotAngle  -3.4167 && rotAngle   -3.2867  && rotAngle  -3.1567 && rotAngle  -3.0267 && rotAngle  -2.8967 && rotAngle  -2.7667 && rotAngle  -2.6367 && rotAngle  -2.5067 && rotAngle  -2.3767 && rotAngle <= -2.2)       //Close to Blue 
      shapeColor = [0, 31.875, 255];                 

    else
      shapeColor = [255, 255, 255];
      
      return shapeColor;
}
void showPatternCoordinates(TouchEvent touchEvent, int shape) {
	int touchCount = touchEvent.touches.length;

	int xTotal=0, yTotal=0;
	for(int i=0; i<touchCount; i++) {
		Touch curTouch = touchEvent.touches[i];
		xTotal += curTouch.offsetX;
		yTotal += curTouch.offsetY;
	}

	PVector centralPt = new PVector(xTotal/touchCount, yTotal/touchCount);       

	for(int i=0; i<touchCount; i++) {
		Touch curTouch = touchEvent.touches[i];
		debugmsg += "(" + str(curTouch.offsetX - (int)centralPt.x) + "," +
		                  str(curTouch.offsetY - (int)centralPt.y) + ") ";
	}
}

void touchStart(TouchEvent touchEvent) {

	for(int i=0; i<touchEvent.changedTouches.length; i++) {
		unassigned.add( touchEvent.changedTouches[i] );
	}

	int shSize = tShapes.size();
	for(int i=0; i<shSize; i++) {
		TouchShape curShape = (TouchShape)tShapes.get(i);

		// skip shapes that are already active
		if(curShape.active) continue;

		// notify it of a touchMove event
		curShape.touchStart(unassigned);
		// if shape became active
		if(curShape.active) {
                        curShape.beforeFirst = false;
			// remove its touches from the unassigned list
			for(int j=0; j<curShape.count; j++) {
				unassigned.remove(curShape.touches[j]);
			}
		}
	}

}

// respond to multitouch events
void touchMove(TouchEvent touchEvent) {
	int shSize = tShapes.size();
	for(int i=0; i<shSize; i++) {
		// notify it of a touchMove event
		((TouchShape)tShapes.get(i)).touchMove(touchEvent);
	}
}

void touchEnd(TouchEvent touchEvent) {
	int removeCount = touchEvent.changedTouches.length;

	// see if the lifted touches were in the unassigned list
	for(int i=0; i<touchEvent.changedTouches.length; i++) {
		if(unassigned.contains(touchEvent.changedTouches[i])) {
			unassigned.remove(touchEvent.changedTouches[i]);
			removeCount--;
		}
	}

	if( removeCount == 0 ) return;

	int shSize = tShapes.size();
	for(int i=0; i<shSize; i++) {
		// notify it of a touchEnd event
                ((TouchShape)tShapes.get(i)).touchEnd(touchEvent);        
	}
}
