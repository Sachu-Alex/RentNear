package com.example.rent_products

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class NearbyItemsWidgetProvider : AppWidgetProvider() {

    data class RentalItem(val name: String, val distance: String, val icon: String)

    private val fallback = listOf(
        RentalItem("Weight Machine", "2 km", "fitness"),
        RentalItem("DSLR Camera", "1.5 km", "camera"),
        RentalItem("Ladder", "800 m", "construction"),
        RentalItem("Drill Machine", "1.2 km", "build")
    )

    private val nameIds = intArrayOf(R.id.name0, R.id.name1, R.id.name2, R.id.name3)
    private val distIds = intArrayOf(R.id.dist0, R.id.dist1, R.id.dist2, R.id.dist3)
    private val iconIds = intArrayOf(R.id.icon0, R.id.icon1, R.id.icon2, R.id.icon3)

    private fun iconRes(type: String): Int = when (type) {
        "fitness"      -> R.drawable.ic_w_dumbbell
        "camera"       -> R.drawable.ic_w_camera
        "construction" -> R.drawable.ic_w_tools
        else           -> R.drawable.ic_w_drill
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_nearby_items)

            for (i in 0..3) {
                val name = prefs.getString("item_${i}_name", null) ?: fallback[i].name
                val dist = prefs.getString("item_${i}_distance", null) ?: fallback[i].distance
                val icon = prefs.getString("item_${i}_icon", null) ?: fallback[i].icon

                views.setTextViewText(nameIds[i], name)
                views.setTextViewText(distIds[i], dist)
                views.setImageViewResource(iconIds[i], iconRes(icon))
            }

            // Tap anywhere → open app
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launchIntent != null) {
                val pi = PendingIntent.getActivity(
                    context, 0, launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_container, pi)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
