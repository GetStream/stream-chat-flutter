///
enum Location {
  ///
  usEast,

  ///
  euWest,

  ///
  mumbai,

  ///
  sydney,

  ///
  singapore,
}

///
extension LocationX on Location {
  ///
  String get name => {
        Location.usEast: 'us-east',
        Location.euWest: 'dublin',
        Location.mumbai: 'mumbai',
        Location.sydney: 'sydney',
        Location.singapore: 'singapore',
      }[this]!;
}
