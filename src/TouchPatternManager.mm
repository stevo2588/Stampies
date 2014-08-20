//==============================================================================
//
//  STAMPIES
//
//  TouchPatternManager.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "TouchPatternManager.h"

#include "Level.h"
#include "TouchPattern.h"

#include <limits>


const Pattern* TouchPatternManager::registerPattern(std::vector<ofVec2f> points, int tolerance) {
    registeredPatterns.push_back(Pattern(points, tolerance));
    
    return &registeredPatterns.back();
}

void TouchPatternManager::unregisterAllPatterns() {
    if (registeredPatterns.empty()) return;
    
    registeredPatterns.clear();
    patInUse = std::vector<bool>(maxPatDetection, false);
}



//--------------------------------------------------------------
void TouchPatternManager::touchDown(ofTouchEventArgs & touchEvent){
    touches[touchEvent.id] = ofVec2f(touchEvent.x, touchEvent.y);
    
    tDown(touches[touchEvent.id]);
}

//-----------------------------------------------------------------------------------------
void TouchPatternManager::touchMoved(ofTouchEventArgs & touchEvent){
    touches[touchEvent.id].set(touchEvent.x, touchEvent.y);
    
    tMoved(touches[touchEvent.id]);
}

//-----------------------------------------------------------------------------------------
void TouchPatternManager::touchUp(ofTouchEventArgs & touchEvent){
    tUp(touches[touchEvent.id]);
    
    touches.erase(touchEvent.id);
}

//-----------------------------------------------------------------------------------------
void TouchPatternManager::tDown(ofVec2f & touch) {
    for( auto& l: listeners ) l->tDown(touch);
    
    unassignedDown(touch);
}

void TouchPatternManager::tMoved(ofVec2f & touch) {
    for( auto& l: listeners ) l->tMoved(touch);
    
    // see if the moved touch was in the unassigned list
    if( std::find(unassigned.begin(), unassigned.end(), &touch) != unassigned.end() ) {
        unassignedMoved(touch);
    }
    
    size_t count = patInUse.size();
    for(int i=0; i<count; i++) {
        if (!patInUse[i]) continue;
        
        auto it = std::find(detectedPatterns[i].touches.begin(), detectedPatterns[i].touches.end(), &touch);
        // if pattern contains the touch
        if(it != detectedPatterns[i].touches.end()) {
            patternMoved(detectedPatterns[i]);
            return;
        }
    }
}

void TouchPatternManager::tUp(ofVec2f & touch) {
    for( auto& l: listeners ) l->tUp(touch);
    
    // see if the lifted touch was in the unassigned list
    if( std::find(unassigned.begin(), unassigned.end(), &touch) != unassigned.end() ) {
        unassignedUp(touch);
    }
    
    size_t count = patInUse.size();
    for(int i=0; i<count; i++) {
        if (!patInUse[i]) continue;
        
        auto it = std::find(detectedPatterns[i].touches.begin(), detectedPatterns[i].touches.end(), &touch);
        // if pattern contains the touch
        if(it != detectedPatterns[i].touches.end()) {
            size_t patTouchIndex = std::distance(detectedPatterns[i].touches.begin(), it);

            patternUp(detectedPatterns[i], i, patTouchIndex);
            return;
        }
    }
}

void TouchPatternManager::unassignedDown(ofVec2f & touch) {
    std::cout << "down: " << touch << std::endl;
    unassigned.push_back( &touch );
    
    for( auto& l: listeners ) l->unassignedDown(touch);
    
    // pattern cannot be less than 3 points
    if (unassigned.size() >= 3) {        
        patternCheckDelay.push_back(frameDelay);
    }
}
void TouchPatternManager::unassignedMoved(ofVec2f & touch) {
    std::cout << "moved: " << touch << std::endl;
    for( auto& l: listeners ) l->unassignedMoved(touch);
    
    // check for patterns
    //lookForPattern();
}

void TouchPatternManager::unassignedUp(ofVec2f & touch) {
    std::cout << "up: " << touch << std::endl;
    for( auto& l: listeners ) l->unassignedUp(touch);
    
    unassigned.erase(std::remove(unassigned.begin(), unassigned.end(), &touch), unassigned.end());
}

void TouchPatternManager::unassignedCancelled(ofVec2f & touch) {
    for( auto& l: listeners ) l->unassignedCancelled(touch);
    
    unassigned.erase(std::remove(unassigned.begin(), unassigned.end(), &touch), unassigned.end());
}

void TouchPatternManager::patternDown(TouchPattern & pat, size_t index) {
    patInUse[index] = true;
    
    for( auto& l: listeners ) l->patternDown(pat);
}

void TouchPatternManager::patternMoved(TouchPattern & pat) {
    pat.updateTransform();
    
    for( auto& l: listeners ) l->patternMoved(pat);
}

void TouchPatternManager::patternUp(TouchPattern & pat, size_t index, size_t touchUpIndex) {
    patInUse[index] = false;
    
    for( auto& l: listeners ) l->patternUp(pat);
    
    // add the pattern touches that are still down to the unassigned touches
    for(int i=0; i<pat.touches.size(); i++) {
        if (i == touchUpIndex) continue;
        
        unassigned.push_back(pat.touches[i]);
    }
}

void TouchPatternManager::updateFrame() {
    for( auto& d: patternCheckDelay ) {
        d--;
        if (d <= 0 && unassigned.size() >= 3) {
            // when the value reaches 0 it will always be the first element of the container
            patternCheckDelay.erase(patternCheckDelay.begin());
            
            lookForPattern();
        }
    }
}

void TouchPatternManager::lookForPattern() {
    unsigned leastUsedTolerance = std::numeric_limits<unsigned>::max();
    std::vector<ofVec2f*> matchingPts;
    Pattern* regPatternMatch = NULL;
    
    //------- check the unassigned points against each registered pattern to find the best match, if any ------
    for( auto& rp: registeredPatterns ) {
        unsigned usedTolerance = 0;
        std::vector<ofVec2f*> possiblePoints = rp.tryPoints(unassigned, usedTolerance);
        if (possiblePoints.empty()) continue;
        
        if (usedTolerance < leastUsedTolerance) {
            matchingPts = possiblePoints;
            leastUsedTolerance = usedTolerance;
            regPatternMatch = &rp;
        }
    }
    
    //------- if one of the registered patterns was found --------
    if (regPatternMatch) {
        TouchPattern tp;
        tp.touches = matchingPts;
        tp.registeredPattern = regPatternMatch;
        registerDetectedPattern(tp);
    }
}

void TouchPatternManager::registerDetectedPattern(TouchPattern tp) {
    // cancel the unassigned touches that were found in the pattern
    for(int j=0; j<tp.touches.size(); j++) {
        unassignedCancelled(*tp.touches[j]);
    }
    
    size_t unusedIndex = getUnusedPatIndex();
    
    detectedPatterns[unusedIndex] = tp;
    detectedPatterns[unusedIndex].updateTransform();
    
    patternDown(detectedPatterns[unusedIndex], unusedIndex);
}

int TouchPatternManager::getUnusedPatIndex() {
    size_t count = patInUse.size();
    for(int i=0; i<count; i++)
        if (!patInUse[i]) return i;
    
    return -1;
}



