dynamic getValueFromMap(Map<String, dynamic> map, String key) {
  print(map);
  var result;
  map.forEach((k, value) {
    if (k == key) {
      result = value;
    }
  });
  return result;
}
