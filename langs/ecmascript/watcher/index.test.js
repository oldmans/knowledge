'use strict';
let ob = require('./index');

let v = {
  v1: 'value',
  stacks: []
};

new ob(v, function (o, n) {
  console.log('changed:', n, '->', o);
});

v.v1 = 'v1';
v.v1 = 'v2';
v.v1 = 'v3';

v.stacks.push('1234');

