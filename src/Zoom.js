'use strict';

export function zoomImpl(d3) { return d3.zoom(); };

export function onImpl(key, func, z) { return z.on(key, func); };

export function renderZoomImpl(zoom, selection) { return selection.call(zoom); };
