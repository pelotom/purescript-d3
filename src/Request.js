'use strict';

exports.csvImpl = function(d3, url, handle) {
  return d3.csv(url, function(row) {
    return handle(row);
  });
};

exports.tsvImpl = function(d3, url, handle) {
  return d3.tsv(url, function(row) {
    return handle(row);
  });
};

exports.jsonImpl = function(d3, url) {
  return d3.json(url);
};
