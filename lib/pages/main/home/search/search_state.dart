import 'package:cus_dbs_app/common/entities/prediction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchState {
  bool isPick = true;
  TextEditingController textSearchCl = TextEditingController();
  RxList<PredictionModel> dropOffPredictionsPlacesList = <PredictionModel>[].obs;
}
