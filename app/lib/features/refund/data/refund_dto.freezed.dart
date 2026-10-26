// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refund_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RefundDto {

 String? get status;@JsonKey(name: 'refund_id') Object? get refundId;@JsonKey(name: 'refunded_at') String? get refundedAt; num? get amount;
/// Create a copy of RefundDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefundDtoCopyWith<RefundDto> get copyWith => _$RefundDtoCopyWithImpl<RefundDto>(this as RefundDto, _$identity);

  /// Serializes this RefundDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefundDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefundDto&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.refundId, _this.refundId)&&(identical(other.refundedAt, _this.refundedAt) || other.refundedAt == _this.refundedAt)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefundDto;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.refundId),_this.refundedAt,_this.amount);
}

@override
String toString() {
  final _this = this as RefundDto;
  return 'RefundDto(status: ${_this.status}, refundId: ${_this.refundId}, refundedAt: ${_this.refundedAt}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $RefundDtoCopyWith<$Res>  {
  factory $RefundDtoCopyWith(RefundDto value, $Res Function(RefundDto) _then) = _$RefundDtoCopyWithImpl;
@useResult
$Res call({
 String? status,@JsonKey(name: 'refund_id') Object? refundId,@JsonKey(name: 'refunded_at') String? refundedAt, num? amount
});




}
/// @nodoc
class _$RefundDtoCopyWithImpl<$Res>
    implements $RefundDtoCopyWith<$Res> {
  _$RefundDtoCopyWithImpl(this._self, this._then);

  final RefundDto _self;
  final $Res Function(RefundDto) _then;

/// Create a copy of RefundDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? refundId = freezed,Object? refundedAt = freezed,Object? amount = freezed,}) {
  return _then(RefundDto(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,refundId: freezed == refundId ? _self.refundId : refundId ,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefundDto].
extension RefundDtoPatterns on RefundDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefundDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefundDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefundDto value)  $default,){
final _that = this;
switch (_that) {
case _RefundDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefundDto value)?  $default,){
final _that = this;
switch (_that) {
case _RefundDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? status, @JsonKey(name: 'refund_id')  Object? refundId, @JsonKey(name: 'refunded_at')  String? refundedAt,  num? amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefundDto() when $default != null:
return $default(_that.status,_that.refundId,_that.refundedAt,_that.amount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? status, @JsonKey(name: 'refund_id')  Object? refundId, @JsonKey(name: 'refunded_at')  String? refundedAt,  num? amount)  $default,) {final _that = this;
switch (_that) {
case _RefundDto():
return $default(_that.status,_that.refundId,_that.refundedAt,_that.amount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? status, @JsonKey(name: 'refund_id')  Object? refundId, @JsonKey(name: 'refunded_at')  String? refundedAt,  num? amount)?  $default,) {final _that = this;
switch (_that) {
case _RefundDto() when $default != null:
return $default(_that.status,_that.refundId,_that.refundedAt,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefundDto extends RefundDto {
  const _RefundDto({this.status, @JsonKey(name: 'refund_id') this.refundId, @JsonKey(name: 'refunded_at') this.refundedAt, this.amount}): super._();
  factory _RefundDto.fromJson(Map<String, dynamic> json) => _$RefundDtoFromJson(json);

@override final  String? status;
@override@JsonKey(name: 'refund_id') final  Object? refundId;
@override@JsonKey(name: 'refunded_at') final  String? refundedAt;
@override final  num? amount;

/// Create a copy of RefundDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefundDtoCopyWith<_RefundDto> get copyWith => __$RefundDtoCopyWithImpl<_RefundDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefundDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefundDto&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.refundId, refundId)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(refundId),refundedAt,amount);
}

@override
String toString() {
    return 'RefundDto(status: $status, refundId: $refundId, refundedAt: $refundedAt, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$RefundDtoCopyWith<$Res> implements $RefundDtoCopyWith<$Res> {
  factory _$RefundDtoCopyWith(_RefundDto value, $Res Function(_RefundDto) _then) = __$RefundDtoCopyWithImpl;
@override @useResult
$Res call({
 String? status,@JsonKey(name: 'refund_id') Object? refundId,@JsonKey(name: 'refunded_at') String? refundedAt, num? amount
});




}
/// @nodoc
class __$RefundDtoCopyWithImpl<$Res>
    implements _$RefundDtoCopyWith<$Res> {
  __$RefundDtoCopyWithImpl(this._self, this._then);

  final _RefundDto _self;
  final $Res Function(_RefundDto) _then;

/// Create a copy of RefundDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? refundId = freezed,Object? refundedAt = freezed,Object? amount = freezed,}) {
  return _then(_RefundDto(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,refundId: freezed == refundId ? _self.refundId : refundId ,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
