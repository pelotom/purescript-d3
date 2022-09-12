/* global exports */
"use strict";

// module Graphics.D3.Scale

export function linearScaleImpl(d3) { return d3.scaleLinear; };

export function powerScaleImpl(d3) { return d3.scalePow; };

export function sqrtScaleImpl(d3) { return d3.scaleSqrt; };

export function logScaleImpl(d3) { return d3.scaleLog; };

export function quantizeScaleImpl(d3) { return d3.scaleQuantize; };

export function quantileScaleImpl(d3) { return d3.scaleQuantile; };

export function thresholdScaleImpl(d3) { return d3.scaleThreshold; };

export function ordinalScaleImpl(d3) { return d3.scaleOrdinal; };
