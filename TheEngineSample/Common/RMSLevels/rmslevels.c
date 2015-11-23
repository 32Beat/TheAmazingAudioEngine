////////////////////////////////////////////////////////////////////////////////
/*
	rmslevels.h
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#include "rmslevels.h"
#include <math.h>


////////////////////////////////////////////////////////////////////////////////

static inline double rms_add(double A, double M, double S)
{ return A + M * (S - A); }

static inline double rms_max(double A, double M, double S)
{ return A > S ? rms_add(A, M, S) : S; }

//static inline double rms_min(double A, double M, double S) \
{ return A < S ? rms_add(A, M, S) : S; }

////////////////////////////////////////////////////////////////////////////////
#pragma mark
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////

rmsengine_t RMSEngineInit(double sampleRate)
{
	rmsengine_t engine = {
	0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0 };
	
	RMSEngineSetResponse(&engine, 300, sampleRate);
	
	return engine;
}

////////////////////////////////////////////////////////////////////////////////

void RMSEngineSetResponse(rmsengine_t *engine, double milliSeconds, double sampleRate)
{
	double decayRate = 0.001 * milliSeconds * sampleRate;
	
	engine->mBalM = 1.0 / (1.0 + decayRate * 10);
	engine->mAvgM = 1.0 / (1.0 + decayRate);
	engine->mMaxM = 1.0 / (1.0 + decayRate);
	engine->mHldM = 1.0 / (1.0 + decayRate * 5);
	
	// default hold time = 1.0 seconds
	engine->mHldT = 1.0 * sampleRate;
}

////////////////////////////////////////////////////////////////////////////////

void RMSEngineAddSample(rmsengine_t *engine, double sample)
{
	// Compute absolute value
	sample = fabs(sample);
	
	// Update clipping counts
	if (sample >= 1.0)
		engine->mClpN += 1;
	engine->mClpD += 1;


	// Update hold value
	if (engine->mHld < sample)
	{
		engine->mHld = sample;
		engine->mHldN = engine->mHldT;
	}
	else
	if (engine->mHldN > 0.0)
	{
		engine->mHldN -= 1.0;
	}
	else
	{
		engine->mHld = rms_add(engine->mHld, engine->mHldM, 0.0);
	}
	
	// Update maximum
	engine->mMax = rms_max(engine->mMax, engine->mMaxM, sample);

	// the s in rms
	sample *= sample;
	
	// Update short term rms average
	engine->mAvg = rms_add(engine->mAvg, engine->mAvgM, sample);

	// Update long term rms average
	engine->mBal = rms_add(engine->mBal, engine->mBalM, sample);
}

////////////////////////////////////////////////////////////////////////////////

void RMSEngineAddSamples32(rmsengine_t *engine, float *srcPtr, uint32_t n)
{
	for (; n!=0; n--)
	RMSEngineAddSample(engine, *srcPtr++);
}

////////////////////////////////////////////////////////////////////////////////

rmsresult_t RMSEngineFetchResult(const rmsengine_t *enginePtr)
{
	rmsresult_t levels = RMSResultZero;
	
	if (enginePtr != NULL)
	{
		levels.mBal = sqrt(enginePtr->mBal);
		levels.mAvg = sqrt(enginePtr->mAvg);
		levels.mMax = enginePtr->mMax;
		levels.mHld = enginePtr->mHld;
	}
	
	return levels;
}

////////////////////////////////////////////////////////////////////////////////
// 20.0*log10(sqrt()) == 10.0*log10()

rmsresult_t RMSEngineFetchResultDB(rmsengine_t *enginePtr)
{
	rmsresult_t levels = RMSEngineFetchResult(enginePtr);
	
	levels.mBal = 10.0*log10(levels.mBal);
	levels.mAvg = 10.0*log10(levels.mAvg);
	levels.mMax = 20.0*log10(levels.mMax);
	levels.mHld = 20.0*log10(levels.mHld);

	return levels;
}

////////////////////////////////////////////////////////////////////////////////





