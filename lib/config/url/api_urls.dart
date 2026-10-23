// ignore_for_file: non_constant_identifier_names

class ApiUrls {
  static String SIGNUP_URL() => "/register";
  static String SIGNIN_URL() => "/login";

  /// businesses
  static String BUSINESSES_URL(int page, String fields) =>
      "/businesses?page=$page" + fields;
  static String POST_BUSINESSES_URL() =>
      "/businesses?filter__status[eq]=Active";
  static String BUSINESSE_URL(String id) => "/businesses/$id";
  static String BUSINESSE_SHOPS_URL(String id) =>
      "/businesses/$id/shops?filter__status[eq]=Active";

  /// shops
  static String PAGE_SHOPS_URL(int page, String fields) =>
      "/shops?page=$page" + fields;
  static String SHOPS_URL() => "/shops?filter__status[eq]=Active";
  static String SHOPss_URL() => "/shops";
  static String SHOP_URL(String id) => "/shops/$id";
  static String SHOP_MAINTENANCES_URL(String id) =>
      "/shops/$id/maintenances?filter__status[eq]=Active";

  /// vehicles
  static String VEHICLES_URL() =>
      "/vehicles?fields=name&fields=mileage&fields=license_plate&filter__status[eq]=Active";
  static String ALL_VEHICLES_URL() =>
      "/vehicles?fields=name&fields=mileage&fields=license_plate&filter__status[eq]=Active";
  static String PAGE_VEHICLES_URL(int page) =>
      "/vehicles?include=model&fields=name&fields=mileage&fields=license_plate&fields=number_of_maintenances&filter__status[eq]=Active&page=$page";
  static String VEHICULE_URL(String id) => "/vehicles/$id";
  static String VEHICULE_CARACTERISTICS_URL(String id) =>
      "/vehicles/$id?include=model";
  static String VEHICULE_MAINTENANCES_URL(String id, int page, String fields) =>
      "/vehicles/$id/maintenances?page=$page" +
      fields +
      '&filter__status[eq]=Active';
  static String VEHICULE_MAINTENANCES_COSTS_URL(
          String id, int page, String fields) =>
      "/vehicles/$id/maintenances" + fields;

  /// drivers
  static String INVITE_DRIVER() => "/drivers?invite";
  static String DRIVERS_URL() => "/drivers?filter__status[eq]=Active";
  static String PAGED_DRIVERS_URL(int page, {String? fields}) =>
      "/drivers?filter__status[eq]=Active&page=$page" + (fields ?? '');
  static String DRIVER_URL(String id, {String? fields}) =>
      "/drivers/$id" + (fields ?? '');

  /// models
  static String MODELS_URL(int page) => "/models";
  static String MODEL_URL(String id) => "/models/$id";

  /// fleets
  static String FLEETS_URL(int page) =>
      "/fleets?page=$page&fields=name&fields=description&fields=number_of_vehicles&fields=number_of_drivers&filter__status[eq]=Active";
  static String FLEET_URL(String id) => "/fleets/$id";
  static String FLEET_DRIVERS_URL(int page, String id) =>
      "/fleets/$id/drivers?page=$page&fields=name&filter__status[eq]=Active";
  static String FLEET_VEHICLES_URL(int page, String id) =>
      "/fleets/$id/vehicles?page=$page&fields=name&fields=mileage&fields=license_plate&filter__status[eq]=Active";

  /// organizations
  static String ORGANIZATIONS_URL() =>
      "/organizations&filter__status[eq]=Active";
  static String ORGANIZATION_URL(String id) => "/organizations/$id";
  static String ORGANIZATION_DRIVERS_URL(String id) =>
      "/organizations/$id/drivers&filter__status[eq]=Active";
  static String ORGANIZATION_FLEETS_URL(String id) =>
      "/organizations/$id/fleets&filter__status[eq]=Active";

  /// maintenances
  static String MAINTENANCES_URL() => "/maintenances";
  static String MAINTENANCES_EXPENSES_URL(String vehicleID, String date) =>
      "/vehicles/$vehicleID/maintenances?include=maintenance_operations&filter__status[eq]=Active&filter__datetime[le]=$date";
  static String PAGE_MAINTENANCES_URL(int page) =>
      "/maintenances?fields=type&sort[desc]=datetime&include=vehicle&fields=datetime&include=shop&fields=mileage&fields=duration&fields=name&fields=total_price&fields=status&fields=alerts&fields=notes&page=$page&filter__status[eq]=Active";
  static String CUSTOM_PAGE_MAINTENANCES_URL(int page, String fields) =>
      "/maintenances?page=$page&filter__status[eq]=Active" + (fields ?? '');
  static String MAINTENANCE_URL(String id, String fields) =>
      "/clients/$id" + fields;
  static String MAINTENANCE_OPERATIONS_URL(String id) =>
      "/clients/$id/operations?include=operation&filter__status[eq]=Active";
  static String MAINTENANCE_OPERATION_URL(String id, String opId) =>
      "/clients/$id/operations/$opId";

  /// operations
  static String OPERATIONS_URL() => "/operations&filter__status[eq]=Active";

  static String OPERATIONS_COMPONENT_URL(String ids, int page) =>
      "/operations?fields=component&filter__id[ic]=$ids&page=$page";

  static String PAGE_OPERATIONS_URL(int page) =>
      "/operations?fields=action&fields=component&fields=specifications&page=$page&filter__status[eq]=Active";
  static String OPERATION_URL(String opId) =>
      "/operations/$opId?fields=action&fields=component&fields=specifications&filter__status[eq]=Active";

  /// expertises
  static String EXPERTS_URL() =>
      "/expertises?fields=name_en&filter__status[eq]=Active";

  /// claim
  static String CLAIMS_URL() => "/claims";
}
