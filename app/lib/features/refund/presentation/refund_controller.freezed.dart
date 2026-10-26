// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refund_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RefundState {

 RefundStage get stage; int get amountCents; String? get reason; String get pin; bool get pinBusy; PinError? get pinError;/// Ошибка запроса — показывается на форме.
 Object? get error; Refund? get result;
/// Create a copy of RefundState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefundStateCopyWith<RefundState> get copyWith => _$RefundStateCopyWithImpl<RefundState>(this as RefundState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RefundState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefundState&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.amountCents, _this.amountCents) || other.amountCents == _this.amountCents)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.pin, _this.pin) || other.pin == _this.pin)&&(identical(other.pinBusy, _this.pinBusy) || other.pinBusy == _this.pinBusy)&&(identical(other.pinError, _this.pinError) || other.pinError == _this.pinError)&&const DeepCollectionEquality().equals(other.error, _this.error)&&(identical(other.result, _this.result) || other.result == _this.result));
}


@override
int get hashCode {
  final _this = this as RefundState;
  return Object.hash(runtimeType,_this.stage,_this.amountCents,_this.reason,_this.pin,_this.pinBusy,_this.pinError,const DeepCollectionEquality().hash(_this.error),_this.result);
}

@override
String toString() {
  final _this = this as RefundState;
  return 'RefundState(stage: ${_this.stage}, amountCents: ${_this.amountCents}, reason: ${_this.reason}, pin: ${_this.pin}, pinBusy: ${_this.pinBusy}, pinError: ${_this.pinError}, error: ${_this.error}, result: ${_this.result})';
}


}

/// @nodoc
abstract mixin class $RefundStateCopyWith<$Res>  {
  factory $RefundStateCopyWith(RefundState value, $Res Function(RefundState) _then) = _$RefundStateCopyWithImpl;
@useResult
$Res call({
 RefundStage stage, int amountCents, String? reason, String pin, bool pinBusy, PinError? pinError, Object? error, Refund? result
});




}
/// @nodoc
class _$RefundStateCopyWithImpl<$Res>
    implements $RefundStateCopyWith<$Res> {
  _$RefundStateCopyWithImpl(this._self, this._then);

  final RefundState _self;
  final $Res Function(RefundState) _then;

/// Create a copy of RefundState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? amountCents = null,Object? reason = freezed,Object? pin = null,Object? pinBusy = null,Object? pinError = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(RefundState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as RefundStage,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,pinBusy: null == pinBusy ? _self.pinBusy : pinBusy // ignore: cast_nullable_to_non_nullable
as bool,pinError: freezed == pinError ? _self.pinError : pinError // ignore: cast_nullable_to_non_nullable
as PinError?,error: freezed == error ? _self.error : error ,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Refund?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefundState].
extension RefundStatePatterns on RefundState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefundState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefundState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefundState value)  $default,){
final _that = this;
switch (_that) {
case _RefundState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefundState value)?  $default,){
final _that = this;
switch (_that) {
case _RefundState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RefundStage stage,  int amountCents,  String? reason,  String pin,  bool pinBusy,  PinError? pinError,  Object? error,  Refund? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefundState() when $default != null:
return $default(_that.stage,_that.amountCents,_that.reason,_that.pin,_that.pinBusy,_that.pinError,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RefundStage stage,  int amountCents,  String? reason,  String pin,  bool pinBusy,  PinError? pinError,  Object? error,  Refund? result)  $default,) {final _that = this;
switch (_that) {
case _RefundState():
return $default(_that.stage,_that.amountCents,_that.reason,_that.pin,_that.pinBusy,_that.pinError,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RefundStage stage,  int amountCents,  String? reason,  String pin,  bool pinBusy,  PinError? pinError,  Object? error,  Refund? result)?  $default,) {final _that = this;
switch (_that) {
case _RefundState() when $default != null:
return $default(_that.stage,_that.amountCents,_that.reason,_that.pin,_that.pinBusy,_that.pinError,_that.error,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _RefundState implements RefundState {
  const _RefundState({this.stage = RefundStage.form, this.amountCents = 0, this.reason, this.pin = '', this.pinBusy = false, this.pinError, this.error, this.result});
  

@override@JsonKey() final  RefundStage stage;
@override@JsonKey() final  int amountCents;
@override final  String? reason;
@override@JsonKey() final  String pin;
@override@JsonKey() final  bool pinBusy;
@override final  PinError? pinError;
/// Ошибка запроса — показывается на форме.
@override final  Object? error;
@override final  Refund? result;

/// Create a copy of RefundState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefundStateCopyWith<_RefundState> get copyWith => __$RefundStateCopyWithImpl<_RefundState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefundState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.pinBusy, pinBusy) || other.pinBusy == pinBusy)&&(identical(other.pinError, pinError) || other.pinError == pinError)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stage,amountCents,reason,pin,pinBusy,pinError,const DeepCollectionEquality().hash(error),result);
}

@override
String toString() {
    return 'RefundState(stage: $stage, amountCents: $amountCents, reason: $reason, pin: $pin, pinBusy: $pinBusy, pinError: $pinError, error: $error, result: $result)';
}


}

/// @nodoc
abstract mixin class _$RefundStateCopyWith<$Res> implements $RefundStateCopyWith<$Res> {
  factory _$RefundStateCopyWith(_RefundState value, $Res Function(_RefundState) _then) = __$RefundStateCopyWithImpl;
@override @useResult
$Res call({
 RefundStage stage, int amountCents, String? reason, String pin, bool pinBusy, PinError? pinError, Object? error, Refund? result
});




}
/// @nodoc
class __$RefundStateCopyWithImpl<$Res>
    implements _$RefundStateCopyWith<$Res> {
  __$RefundStateCopyWithImpl(this._self, this._then);

  final _RefundState _self;
  final $Res Function(_RefundState) _then;

/// Create a copy of RefundState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? amountCents = null,Object? reason = freezed,Object? pin = null,Object? pinBusy = null,Object? pinError = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(_RefundState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as RefundStage,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,pinBusy: null == pinBusy ? _self.pinBusy : pinBusy // ignore: cast_nullable_to_non_nullable
as bool,pinError: freezed == pinError ? _self.pinError : pinError // ignore: cast_nullable_to_non_nullable
as PinError?,error: freezed == error ? _self.error : error ,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Refund?,
  ));
}


}

// dart format on
