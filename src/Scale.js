/* global exports */
"use strict";

// module Graphics.D3.Scale

exports.linearScale = d3.scale.linear;

exports.powerScale = d3.scale.pow;

exports.sqrtScale = d3.scale.sqrt;

exports.logScale = function() {
    return d3.scale.log();
};

exports.quantizeScale = d3.scale.quantize;

exports.quantileScale = d3.scale.quantile;

exports.thresholdScale = d3.scale.threshold;

exports.ordinalScale = d3.scale.ordinal;
