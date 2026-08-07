package com.example.flutter_application_1

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver

// AndroidManifest.xml'deki <receiver> kaydı bu sınıfı işaret eder. Dart
// tarafındaki note_widget_service.dart içinde tanımlı
// _androidQualifiedReceiver sabiti de bu sınıfın tam adıyla (paket dahil)
// birebir eşleşmelidir:
//   com.example.flutter_application_1.NoteWidgetReceiver
class NoteWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = NoteWidget()
}
