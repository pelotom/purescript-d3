/* global exports */
"use strict";

// module Graphics.D3.Scale

exports.linearScaleImpl = function(d3) { return d3.scaleLinear; };

exports.powerScaleImpl = function(d3) { return d3.scalePow; };

exports.sqrtScaleImpl = function(d3) { return d3.scaleSqrt; };

exports.logScaleImpl = function(d3) { return d3.scaleLog; };

exports.quantizeScaleImpl = function(d3) { return d3.scaleQuantize; };

exports.quantileScaleImpl = function(d3) { return d3.scaleQuantile; };

exports.thresholdScaleImpl = function(d3) { return d3.scaleThreshold; };

exports.ordinalScaleImpl = function(d3) { return d3.scaleOrdinal; };
