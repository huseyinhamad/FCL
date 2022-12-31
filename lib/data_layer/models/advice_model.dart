import 'package:equatable/equatable.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';

class AdviceModel extends AdviceEntity with EquatableMixin {
  AdviceModel({required super.advice, required super.id});

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(
      advice: json["advice"],
      id: json["advice_id"],
    );
  }
}
