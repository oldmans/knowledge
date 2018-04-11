/**
 * Created by admin on 2015/8/8.
 */

var Promise = require('./core');

var val = 1;

function step1(resolve, reject) {
	console.log('步骤一：执行');
	if (val >= 1) {
		resolve('Hello I am No.1');
	} else if (val === 0) {
		reject(val);
	}
}

function step2(resolve, reject) {
	console.log('步骤二：执行');
	if (val === 1) {
		resolve('Hello I am No.2');
	} else if (val === 0) {
		reject(val);
	}
}

function step3(resolve, reject) {
	console.log('步骤三：执行');
	if (val === 1) {
		resolve('Hello I am No.3');
	} else if (val === 0) {
		reject(val);
	}
}

new Promise(step1).then(function () {
	return new Promise(step2);
}).then(function () {
	return new Promise(step3);
});


