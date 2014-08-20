//==============================================================================
//
//  STAMPIES
//
//  main.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "ofMain.h"
#include "testApp.h"

int main(){
    //ofAppiOSWindow * window = new ofAppiOSWindow();
    //window->enableHardwareOrientation();
    //window->enableOrientationAnimation();
    
	ofSetupOpenGL(1024, 768, OF_FULLSCREEN);			// <-------- setup the GL context
    
    //ofSetDataPathRoot("./data");
	ofRunApp( new testApp() );
}
