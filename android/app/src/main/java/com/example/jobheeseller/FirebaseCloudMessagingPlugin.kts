package com.example.jobheeseller

import io.flutter.plugin.common.PluginRegistry



object FirebaseCloudMessagingPlugin{
    fun registerWith(pluginRegistery: PluginRegistry){
             if(alreadyRegistrWith(pluginRegistery)) {
                 return
             }
            registerWith(pluginRegistery)
    }
    private fun alreadyRegistrWith(pluginRegistery: PluginRegistry): Boolean{
            val key=FirebaseCloudMessagingPlugin::class.java.cononicalName
            if(pluginRegistery.hasPlugin(key)) return true
           pluginRegistery.registrarFor(key) return false
    }
}