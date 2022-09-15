'use strict';

var window = window || undefined;
import * as d3 from 'd3';

if (window !== undefined) {
  window.d3 = d3;
}

export { d3 };
