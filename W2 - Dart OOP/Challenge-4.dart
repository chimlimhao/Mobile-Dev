class Distance {
  final num _duration;

  const Distance.cms(num duration_in_cms) : _duration = duration_in_cms;
  const Distance.meters(num duration_in_cms)
      : _duration = duration_in_cms * 100;
  const Distance.kms(num duration_in_cms)
      : _duration = duration_in_cms * 100000;

  num get cms => _duration;
  num get meters => _duration / 100;
  num get kms => _duration / 100000;

  @override
  String toString() {
    return "Distance in:\n- cms: ${cms} cm\n- meters: ${meters} m\n- kms: ${kms} km";
  }

  Distance operator +(covariant Distance d) {
    return Distance.cms(cms + d.cms);
  }
}

void main() {
  final Distance d1 = Distance.cms(100);
  final Distance d2 = Distance.meters(1);
  final Distance d3 = d1 + d2;
  // print((d1 + d2).kms);
  print(d3);
  // d1 = d2;
  // print(d1);
  // d3 = d3 + d1;
  // print(d3);
}
