function lookup(array, prop, value) {
  for (var i = 0, len = array.length; i < len; i++)
      if (array[i] && array[i][prop] === value) return array[i];
}