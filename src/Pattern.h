//==============================================================================
//
//  STAMPIES
//
//  Pattern.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Colors_TouchShape_h
#define Colors_TouchShape_h

#include "ofMain.h"

#include <vector>

class Pattern {
public:
    Pattern(std::vector<ofVec2f> points, int tol);
    
    //std::vector<ofVec2f> points;
    std::vector<ofVec2f> vectors;
    std::vector<float> angles; // holds angles between vectors and the first vector
	int tolerance;
    
	//ofVec2f firstToSecond;
	//float distToFirst[9];
    
	std::vector<ofVec2f*> tryPoints(const std::vector<ofVec2f*>& points, unsigned &usedTolerance);
private:
    //std::vector<ofVec2f*> tryPoints(ofVec2f* mainPt, const std::vector<ofVec2f *> &points, unsigned int &usedTolerance);
    bool tryPoints(const ofVec2f* mainPt, const std::vector<ofVec2f *> &t, unsigned int &usedTolerance);
    
    //std::vector<std::vector<ofVec2f*> > getEveryCombo(std::vector<ofVec2f*> points, size_t comboSize);
    
    //size_t getNumCombos(size_t setSize, size_t comboSize);
    //void getEveryCombo(std::vector<ofVec2f*> points, size_t comboSize, int offset, std::vector<ofVec2f*>& combo, std::vector<std::vector<ofVec2f*> >& out);
};

#endif

