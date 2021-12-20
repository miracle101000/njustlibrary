class SearchParamtersModel {
  List fieldList = [],
      filters = [],
      limiter = [],
      campusLocations = [],
      singleLocations = [];
  String? sortField, sortType;

  SearchParamtersModel(
      {required this.fieldList,
      required this.filters,
      required this.limiter,
      required this.campusLocations,
      required this.singleLocations,
      required this.sortField,
      required this.sortType});
}
