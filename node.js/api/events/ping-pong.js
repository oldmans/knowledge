'use strict';
var util = require('util');
var events = require('events');

var EventEmitter = events.EventEmitter;

function MyEventEmitter(timeout) {
  EventEmitter.call(this);

  this._timeout = timeout || 1000;

  this.on('ping', function (times) {
    console.log('ping', times);
    var self = this;
    setTimeout(function () {
      self.emit('pong', ++times);
    }, self._timeout);
  });

  this.on('pong', function (times) {
    console.log('pong', times);
    var self = this;
    setTimeout(function () {
      self.emit('ping', ++times);
    }, self._timeout)
  });
}

// Inherit functions from `EventEmitter`'s prototype
util.inherits(MyEventEmitter, EventEmitter);

MyEventEmitter.prototype.ping = function () {
  this.emit('ping', 1);
};

MyEventEmitter.prototype.pong = function () {
  this.emit('pong', 1);
};

var ee = new MyEventEmitter();

ee.ping();
