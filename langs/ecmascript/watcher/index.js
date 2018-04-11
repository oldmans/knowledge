'use strict';
const arrayPrototype = Array.prototype;
const objectPrototype = Object.prototype;

let isArray = function (obj) {
  return objectPrototype.toString.call(obj) === '[object Array]';
};

let isObject = function (obj) {
  return objectPrototype.toString.call(obj) === '[object Object]';
};

let isFunction = function () {
  return (typeof f === 'function');
};

const OAM = ['push', 'pop', 'shift', 'unshift', 'splice', 'sort', 'reverse'];

module.exports = Watcher;

function Watcher(obj, callback) {
  if (!isObject(obj)) {
    throw Error('This parameter must be an object, but a ' + obj);
  }
  this.$callback = callback;
  this.observe(obj);
}

Watcher.prototype.overrideArrayProto = function (array, path) {
  array.__proto__ = (function (array, path) {
    let overrideProto = Object.create(Array.prototype);
    for (let method of OAM) {
      Object.defineProperty(overrideProto, method, {
        value: () => {
          let result = arrayPrototype[method].apply(this, [].slice.apply(arguments));
          this.$callback(result, [].slice.apply(arguments));
          return result;
        },
        writable: true,
        enumerable: false,
        configurable: true
      });
    }
    return overrideProto;
  })(array, path);
};

Watcher.prototype.observe = function (obj) {
  if (isArray(obj)) {
    this.overrideArrayProto(obj);
  }
  Object.keys(obj).forEach((key) => {
    var saveValue = obj[key];
    if (!isFunction(saveValue)) {
      Object.defineProperty(obj, key, {
        get: function () {
          return saveValue;
        },
        set: (function (newVal) {
          if (saveValue !== newVal) {
            if (isObject(newVal) || isArray(obj)) {
              this.observe(newVal);
            }
            this.$callback(newVal, saveValue);
            saveValue = newVal;
          }
        }).bind(this)
      });

      if (isObject(saveValue) || isArray(obj)) {
        this.observe(obj[key]);
      }
    }
  }, this);
};
