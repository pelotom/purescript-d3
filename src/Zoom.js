'use strict';

exports.zoomImpl = function(d3) { return d3.zoom(); };

exports.onImpl = function(key, func, z) { return z.on(key, func); };

exports.renderZoomImpl = function(zoom, selection) { return selection.call(zoom); };
