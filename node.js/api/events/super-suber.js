
function Super(name) {
  var _name = name;
  this._sayMyName = function () {
    return _name;
  }
}

Super.prototype.sayMyName = function () {
  console.log(this._sayMyName());
};

function Suber(name){
  Super.call(this, name);
}

Suber.prototype = new Super();

Suber.prototype.constructor = Suber;

var obj = new Suber('I\'m Suber', 'I\'m Super');

obj.sayMyName();
