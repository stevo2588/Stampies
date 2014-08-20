//==============================================================================
//
//  STAMPIES
//
//  Pattern.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "Pattern.h"

#include "Utility.h"

#include "ofMain.h"

#include <vector>
#include <limits>

Pattern::Pattern(std::vector<ofVec2f> points, int tol) : /*points(points),*/ tolerance(tol)
{
    //firstToSecond = points[0] - points[1];
    
    size_t vertCount = points.size();
    for(int i=1; i<vertCount; i++) {
        //distToFirst[i-1] = points[0].distance(points[i]);
        vectors.push_back(points[i] - points[0]);
    }
    
    size_t vectorCount = vectors.size();
    for (int i=1; i<vectorCount; i++) {
        angles.push_back(Utility::angleBetween(vectors[0], vectors[i]));
    }
}


// returns a vector of the points that form the pattern, vector is empty if pattern was not found
std::vector<ofVec2f*> Pattern::tryPoints(const std::vector<ofVec2f*>& points, unsigned &usedTolerance) {
    
    usedTolerance = std::numeric_limits<unsigned>::max();
    
    int pointCount = points.size();
    size_t vectorCount = vectors.size();
    
    // return empty vector if there aren't enough points to form this pattern
    if(pointCount < vectorCount+1) return std::vector<ofVec2f*>();
    
    for (int i=0; i<pointCount; i++) {
        ofVec2f* mainPt = points[i];
        
        std::vector<ofVec2f*> check;
        for(int j=0; j<pointCount; j++) {
            if (i == j) continue;
            
            check.push_back(points[j]);
        }
        
        // TODO: this could get pretty memory expensive for patterns with a lot of points. Have a function
        // that returns a single combo and takes an index instead?
        std::vector<std::vector<ofVec2f*> > combos = Utility::getEveryCombo(check, vectors.size());
        
        for ( auto& c: combos ) {
            if(tryPoints(mainPt, c, usedTolerance)) {
                c.insert(c.begin(), mainPt);
                return c;
            }
        }
    }
    
    return std::vector<ofVec2f*>();
     
    
    /*
    // for each point in t
    for(int i=0; i<tSize; i++) {
        potential.push_back(t[i]);
        std::vector<ofVec2f*> check(t);
        ofVec2f curPt(t[i]->x, t[i]->y);
        int tSize2 = tSize;
        
        usedTolerance = tolerance;
        // for each distance we are looking for
        for(int j=0; j<vertCount-1; j++) {
            // check all distances to the current point
            for(int ptIndex=0; ptIndex < tSize2; ptIndex++) {
                // no need to check distance between current point and itself
                if(ptIndex == i) continue;
                
                float dist = curPt.distance(ofVec2f(check[ptIndex]->x, check[ptIndex]->y));
                
                int used = abs(distToFirst[j] - dist);
                
                //int used = tolerance - toleranceNeeded;
                
                if(used > tolerance) continue;
                
                usedTolerance += used;
                
                potential.push_back(check[ptIndex]);
                check.erase(check.begin() + ptIndex);
                ptIndex--;
                tSize2--;
            }
        }
        
        // if everything matched then set the touch array and return true
        if(potential.size() == vertCount) {
            return potential;
        }
        
        potential.clear();
    }
    
    
    return potential;
    */
    
    /*
    int pointCount = points.size();
    size_t vectorCount = vectors.size();
    
    unsigned t = std::numeric_limits<unsigned>::max();
    std::vector<ofVec2f*> bestPts;
    
    // return empty vector if there aren't enough points to form this pattern
    if(pointCount < vectorCount+1) return std::vector<ofVec2f*>();
    
    // iterate through all points, trying each points as the "main" point
    for (int i=0; i<pointCount; i++) {
        ofVec2f* mainPt = points[i];
        
        // put all the other points in a container
        std::vector<ofVec2f*> otherPts;
        for(int j=0; j<pointCount; j++) {
            if (i == j) continue;
            
            otherPts.push_back(points[j]);
        }
        
        unsigned tolTemp;
        std::vector<ofVec2f*> ptsTemp;
        ptsTemp = tryPoints(mainPt, otherPts, tolTemp);
        if (ptsTemp.size() == 0) continue;
        
        if (tolTemp < t) {
            bestPts = ptsTemp;
            t = tolTemp;
        }
    }
    
    usedTolerance = t;
    return bestPts;
     */
}

/*
std::vector<ofVec2f*> Pattern::tryPoints(ofVec2f* mainPt, const std::vector<ofVec2f *> &otherPts,
                                         unsigned &usedTolerance)
{
    // each container represents a pattern based on one of the potentialSeconds
    // the outermost inner container holds the number of points that could match the pattern
    // the innermost container holds the options for each
    std::vector<std::vector<std::vector<unsigned> > > potentialUsedTol;
    std::vector<std::vector<std::vector<ofVec2f *> > > potentialPattern;
    
    // first find which points could be the second point (the point that forms the first vector with the main point)
    // these will be used to get an orientation from which we can check the rest of the points
    for (int i=0; i<otherPts.size(); i++) {
        float dist = mainPt->distance(*otherPts[i]);
        
        int used = abs(vectors[0].length() - dist);
        
        if(used < tolerance) {
            potentialPattern.push_back(std::vector<std::vector<ofVec2f*> >(1, std::vector<ofVec2f*>(1,otherPts[i])));
            potentialUsedTol.push_back(std::vector<std::vector<unsigned> >(1, std::vector<unsigned>(1,used)));
        }
    }
    
    
    //
    for (int i=0; i<potentialPattern.size(); i++) {
        ofVec2f potentialFirstVector = *potentialPattern[i][0][0] - *mainPt;
        
        // calculate the rotation to orient this vector with the pattern's
        float correctRot = Utility::angleBetween(vectors[0], potentialFirstVector);
        
        // for every other point check with pattern
        for (int j=0; j<otherPts.size(); j++) {
            // don't reuse the potential second
            if (potentialPattern[i][0][0] == otherPts[j]) continue;
            
            potentialPattern[i].push_back(std::vector<ofVec2f*>());
            potentialUsedTol[i].push_back(std::vector<unsigned>());
            
            ofVec2f curVec = (*otherPts[j] - *mainPt).rotateRad(correctRot);
            
            // we check each point for all vectors (except first) to make sure we get the best fit
            for (int k=1; k<vectors.size(); k++) {
                unsigned t = curVec.distance(vectors[k]);
                if( t < tolerance ) {
                    // use j+1 so we offset 1 from the second point
                    potentialPattern[i][j+1].push_back( otherPts[j] );
                    potentialUsedTol[i][j+1].push_back( t );
                }
            }
        }
    }
    
    std::vector<ofVec2f*> thePattern;
    
    size_t totalLowestTolIndex = 0;
    unsigned totalLowestTolerance = 0;
    for ( int i=0; i<potentialPattern.size(); i++ ) {
        
        // if a potential pattern is not big enough, remove it
        if (potentialPattern[i].size() < vectors.size()) {
            potentialPattern[i].clear();
            potentialUsedTol[i].clear();
            potentialPattern.erase(potentialPattern.begin() + i);
            potentialUsedTol.erase(potentialUsedTol.begin() + i);
            i--;
            continue;
        }
        
        unsigned totalTolNeeded = 0;
        // for each pattern's potential points
        for (int j=0; j<potentialPattern[i].size(); j++) {
            
            size_t curLowestTolIndex = 0;
            unsigned curLowestTolerance = std::numeric_limits<unsigned>::max();
            // for each point option
            for ( int k=0; k<potentialPattern[i][j].size(); k++) {
                if ( potentialUsedTol[i][j][k] < curLowestTolerance ) {
                    potentialUsedTol[i][j].erase(potentialUsedTol[i][j].begin() + curLowestTolIndex);
                    potentialPattern[i][j].erase(potentialPattern[i][j].begin() + curLowestTolIndex);
                    k--;
                    curLowestTolerance = potentialUsedTol[i][j][k];
                    curLowestTolIndex = k;
                }
            }
            
            totalTolNeeded += curLowestTolerance;
        }
        
        if ( totalTolNeeded < totalLowestTolerance ) {
            totalLowestTolerance = totalTolNeeded;
            totalLowestTolIndex = i;
        }
    }
    
    // if no patterns were found, return empty container
    if (potentialPattern.empty()) return thePattern;
    
    usedTolerance = totalLowestTolerance;
    
    // take everything left in potentialPattern and put it in thePattern
    for (int i=0; i<potentialPattern[totalLowestTolIndex].size(); i++) {
        for (int j=0; j<potentialPattern[totalLowestTolIndex][i].size(); j++) {
            thePattern.push_back(potentialPattern[totalLowestTolIndex][i][j]);
        }
    }
    
    
    thePattern.insert(thePattern.begin(), mainPt); // make sure we put the main point in
    //thePattern.push_back(mainPt);
    return thePattern;
}
 */


bool Pattern::tryPoints(const ofVec2f* mainPt, const std::vector<ofVec2f *> &t, unsigned int &usedTolerance) {
    
    
    if (t.size() != vectors.size()) return false;
    
    // check distances
    for (int i=0; i<t.size(); i++) {
        float dist = mainPt->distance(*t[i]);
        
        int used = abs(vectors[i].length() - dist);
 
        if(used > tolerance) return false;
        
        usedTolerance += used;
    }
    
    // check angles
    for (int i=0; i<angles.size(); i++) {
        float angleTolerance = 15.0f;
        
        float a = Utility::angleBetween(*t[i] - *mainPt, *t[i+1] - *mainPt);
        
        int used = abs(angles[i] - a);
 
        if(used > angleTolerance) return false;
        
        usedTolerance += used;
    }
    
    return true;
}

