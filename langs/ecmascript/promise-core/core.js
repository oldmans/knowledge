'use strict'

module.exports = function Promise(fn) {
	if (!(this instanceof Promise)) {
		return new Promise(fn);
	}

	if (typeof fn !== 'function') {
		throw new TypeError('fn not a function');
	}

	var state = null;
	var delegating = false;
	var value = null;
	var deferreds = [];
	var self = this;

	this.then = function (onFulfilled, onRejected) {
		return new Promise(function (resolve, reject) {
			handle(new Handler(onFulfilled, onRejected, resolve, reject));
		});
	};

	function handle(deferred) {
		if (state === null) {
			deferreds.push(deferred);
			return;
		}

		process.nextTick(function() {
			var cb = state ? deferred.onFulfilled : deferred.onRejected;
			if (cb === null) {
				(state ? deferred.resolve : deferred.reject)(value);
				return;
			}
			var ret;
			try {
				ret = cb(value);
			}
			catch (e) {
				deferred.reject(e);
				return;
			}
			deferred.resolve(ret);
		})
	}

	function resolve(newValue) {
		if (delegating) {
			return;
		}
		_resolve(newValue);
	}

	function _resolve(newValue) {
		if (state !== null) {
			return;
		}
		try {
			if (newValue === self) {
				throw new TypeError('Chaining cycle detected for promise #<Promise>');
			}

			// 适用 resolve(new Promise()) 情形
			if (newValue
				&& (typeof newValue === 'object' || typeof newValue === 'function')
				&& typeof newValue.then === 'function') {
					delegating = true;
					newValue.then.call(newValue, _resolve, _reject);
					return;
			}
			state = true;
			value = newValue;
			finale();
		}
		catch (e) {
			_reject(e);
		}
	}

	function reject(newValue) {
		if (delegating) {
			return;
		}
		_reject(newValue);
	}

	function _reject(newValue) {
		if (state !== null) {
			return;
		}
		state = false;
		value = newValue;
		finale();
	}

	function finale() {
		for (var i = 0, len = deferreds.length; i < len; i++) {
			handle(deferreds[i]);
		}
		deferreds = null;
	}

	try {
		fn(resolve, reject);
	}
	catch (e) {
		reject(e);
	}
};

function Handler(onFulfilled, onRejected, resolve, reject) {
	this.onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : null;
	this.onRejected = typeof onRejected === 'function' ? onRejected : null;
	this.resolve = resolve;
	this.reject = reject;
}
