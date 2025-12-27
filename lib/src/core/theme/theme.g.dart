// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppThemeImpl _$$AppThemeImplFromJson(Map<String, dynamic> json) =>
    _$AppThemeImpl(
      name: json['name'] as String,
      scaffoldBackgroundColor: const ColorConverter().fromJson(
        json['scaffoldBackgroundColor'] as String,
      ),
      appBarBackgroundColor: const ColorConverter().fromJson(
        json['appBarBackgroundColor'] as String,
      ),
      textColor: const ColorConverter().fromJson(json['textColor'] as String),
      accentColor: const ColorConverter().fromJson(
        json['accentColor'] as String,
      ),
      editorBackgroundColor: const ColorConverter().fromJson(
        json['editorBackgroundColor'] as String,
      ),
      editorTextColor: const ColorConverter().fromJson(
        json['editorTextColor'] as String,
      ),
      previewBackgroundColor: const ColorConverter().fromJson(
        json['previewBackgroundColor'] as String,
      ),
      previewTextColor: const ColorConverter().fromJson(
        json['previewTextColor'] as String,
      ),
      sidebarBackgroundColor: const ColorConverter().fromJson(
        json['sidebarBackgroundColor'] as String,
      ),
      sidebarTextColor: const ColorConverter().fromJson(
        json['sidebarTextColor'] as String,
      ),
      sidebarHighlightColor: const ColorConverter().fromJson(
        json['sidebarHighlightColor'] as String,
      ),
    );

Map<String, dynamic> _$$AppThemeImplToJson(
  _$AppThemeImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'scaffoldBackgroundColor': const ColorConverter().toJson(
    instance.scaffoldBackgroundColor,
  ),
  'appBarBackgroundColor': const ColorConverter().toJson(
    instance.appBarBackgroundColor,
  ),
  'textColor': const ColorConverter().toJson(instance.textColor),
  'accentColor': const ColorConverter().toJson(instance.accentColor),
  'editorBackgroundColor': const ColorConverter().toJson(
    instance.editorBackgroundColor,
  ),
  'editorTextColor': const ColorConverter().toJson(instance.editorTextColor),
  'previewBackgroundColor': const ColorConverter().toJson(
    instance.previewBackgroundColor,
  ),
  'previewTextColor': const ColorConverter().toJson(instance.previewTextColor),
  'sidebarBackgroundColor': const ColorConverter().toJson(
    instance.sidebarBackgroundColor,
  ),
  'sidebarTextColor': const ColorConverter().toJson(instance.sidebarTextColor),
  'sidebarHighlightColor': const ColorConverter().toJson(
    instance.sidebarHighlightColor,
  ),
};
