function lookup(array, prop, value) {
  for (var i = 0, len = array.length; i < len; i++)
      if (array[i] && array[i][prop] === value) return array[i];
}

var _toastr = function(type, message, options){
  message = typeof message !== 'undefined' ? message : 'Our robots cannot perform that action right now :(';
  type = typeof type !== 'undefined' ? type : 'success'; // Default to success toastr
  options = typeof options !== 'undefined' ? options : { 'positionClass': 'toast-top-center' };
  toastr.options = options;
  toastr[type](message);
}