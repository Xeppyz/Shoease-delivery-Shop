
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shoes/src/models/user.dart';
import 'package:shoes/src/provider/users_provider.dart';
import 'package:http/http.dart' as http;
class PushNotificationsProvider {
    // Canal de notificación para Android
    late AndroidNotificationChannel channel;
    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    final _firebaseMessaging = FirebaseMessaging.instance;
    // Variable para verificar si las notificaciones ya fueron inicializadas
    bool isFlutterLocalNotificationsInitialized = false;



    /// Inicializa las notificaciones push y solicita permisos
    Future<void> initNotifications() async {
        if (isFlutterLocalNotificationsInitialized) return;

        // Crear un canal de notificaciones para Android
        channel = const AndroidNotificationChannel(
            'high_importance_channel', // ID del canal
            'High Importance Notifications', // Nombre del canal
            description: 'Este canal es para notificaciones importantes.', // Descripción
            importance: Importance.high,
        );

        // Inicializar el plugin de notificaciones locales
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        // Configurar el canal en Android
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        // Configurar la presentación de notificaciones en iOS
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
        );

        isFlutterLocalNotificationsInitialized = true;

        // Solicitar permisos en iOS
        requestPermissions();

        // Configurar los listeners para recibir notificaciones
        noMessageListener();
    }

    /// Solicita permisos de notificaciones en iOS
    void requestPermissions() {
        FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
        ).then((NotificationSettings settings) {
            print('Permisos concedidos: ${settings.authorizationStatus}');
        });
    }

    /// Muestra una notificación en la pantalla cuando se recibe un mensaje
    void showFlutterNotification(RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null && !kIsWeb) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                    android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                        channelDescription: channel.description,
                        icon: 'launch_background', // Asegúrate de que este recurso exista
                    ),
                ),
            );
        }
    }

    /// Configura los listeners para manejar mensajes en diferentes estados de la app
    void noMessageListener() {
        // Mensaje recibido cuando la app se inicia desde una notificación
        FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
            if (message != null) {
                print('Mensaje inicial: ${message.notification?.title}');
                // Manejar la lógica del mensaje inicial
            }
        });

        // Mensajes recibidos en primer plano
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            print('Mensaje en primer plano: ${message.notification?.title}');
            showFlutterNotification(message); // Mostrar la notificación en la pantalla
        });

        // Mensajes recibidos cuando la app estaba en segundo plano y se abre desde una notificación
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
            print('Mensaje abierto: ${message.notification?.title}');

            // Manejar la navegación o lógica aquí
        });
    }

    void saveToken(User user, BuildContext context)async {
        print("HOLA INICIO");
        String? token = await FirebaseMessaging.instance.getToken();
        print("HOLA INICIO2");

        UsersProvider usersProvider = new UsersProvider();
        usersProvider.init(context, sessionUser: user);
        usersProvider.updateNotificationToken(user.id!, token!);
    }

        Future<void> sendMessage (String to, Map<String, dynamic> data, String title, String body ) async {
                Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');
                print("URL: ${uri}");
                await http.post(
                    uri,
                    headers: <String, String> {
                        'Content-Type': 'application/json',
                        'Authorization': 'key=AIzaSyD52Ib9CbUKtzwF-qGmOC6xPKNnwHzBZac'
                    },
                    body: jsonEncode(
                    <String, dynamic>{
                        'notification': <String, dynamic> {
                            'body': body,
                            'title': title,
                        },
                        'priority': 'high',
                        'ttl': '4500s',
                        'data': data,
                        'to': to
                    }
                    )

                );
        }
}
