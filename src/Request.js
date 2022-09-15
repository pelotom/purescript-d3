'use strict';

export function csvImpl(d3, url, handle) {
  return d3.csv(url, function(row) {
    return handle(row);
  });
};

export function tsvImpl(d3, url, handle) {
  return d3.tsv(url, function(row) {
    return handle(row);
  });
};

export function jsonImpl(d3, url) {
  return d3.json(url);
};

export function xmlImpl(d3, url) {
  return d3.xml(url);
};
