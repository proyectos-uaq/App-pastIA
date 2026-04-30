# PastIA – App Móvil

> Aplicación móvil desarrollada con **Flutter** para mejorar la **adherencia a medicamentos** mediante un algoritmo de inteligencia artificial basado en Reinforcement Learning (RL).

La app permite gestionar recetas, medicamentos y horarios de ingesta. La sesión se mantiene mediante un **token JWT** almacenado de forma segura en el dispositivo.

---

## Tabla de Contenidos

- [Características](#características)
- [Tecnologías](#tecnologías)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Ejecución en Local](#ejecución-en-local)
- [Build / Release](#build--release)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración de API / Backend](#configuración-de-api--backend)
- [Contribución](#contribución)
- [Licencia](#licencia)

---

## Características

- **Persistencia de sesión por token:** Si existe un token guardado, la app abre directamente la pantalla principal; de lo contrario, redirige al Login.
- **Autenticación:** Registro e inicio de sesión de usuarios.
- **Gestión de recetas y medicamentos:** Visualización, creación y actualización de recetas y medicamentos.
- **Horarios de ingesta:** Seguimiento de los horarios de toma de medicamentos.
- **Algoritmo RL:** Motor de inteligencia artificial para personalizar y reforzar la adherencia al tratamiento.
- **UI responsiva:** Indicadores de carga, iconografía y formato de fechas localizado.

### Pantallas / Rutas principales

| Ruta                  | Descripción                        |
|-----------------------|------------------------------------|
| `/login`              | Inicio de sesión                   |
| `/signup`             | Registro de usuario                |
| `/home`               | Pantalla principal                 |
| `/prescriptionDetails`| Detalle de receta                  |
| `/medicationDetails`  | Detalle de medicamento             |
| `/createMedication`   | Crear medicamento                  |
| `/updateMedication`   | Actualizar medicamento             |

> El token se almacena con la clave `token` mediante `flutter_secure_storage`.

---

## Tecnologías

| Paquete                   | Uso                                      |
|---------------------------|------------------------------------------|
| **Flutter / Dart**        | Framework principal                      |
| **flutter_riverpod**      | Gestión de estado                        |
| **flutter_secure_storage**| Almacenamiento seguro del token JWT      |
| **http**                  | Consumo de la API REST                   |
| **intl**                  | Formato de fechas y localización         |
| **font_awesome_flutter**  | Iconografía                              |
| **loading_indicator**     | Indicadores de carga                     |

Dependencias completas declaradas en `pubspec.yaml`.

---

## Requisitos

- **Flutter SDK** (canal stable)
- **Dart SDK** `^3.7.0` (indicado en `pubspec.yaml`)
- Android Studio / Xcode según plataforma objetivo
- Dispositivo físico o emulador/simulador (opcional)

Verifica tu instalación con:

```bash
flutter --version
flutter doctor
```

---

## Instalación

1. **Clona el repositorio:**

   ```bash
   git clone https://github.com/proyectos-uaq/App-pastIA.git
   cd App-pastIA
   ```

2. **Descarga las dependencias:**

   ```bash
   flutter pub get
   ```

---

## Ejecución en Local

### Android

Asegúrate de tener un emulador abierto o un dispositivo conectado, luego ejecuta:

```bash
flutter run
```

### iOS (macOS)

1. Instala los pods si es necesario:

   ```bash
   cd ios
   pod install
   cd ..
   ```

2. Ejecuta la app:

   ```bash
   flutter run
   ```

### Web

```bash
flutter run -d chrome
```

---

## Build / Release

```bash
# APK para Android
flutter build apk

# Build para iOS
flutter build ios
```

---

## Estructura del Proyecto

```
App-pastIA/
├── lib/                  # Código principal Flutter
│   ├── screens/          # Pantallas (login, home, recetas, medicamentos…)
│   ├── providers/        # Providers de Riverpod
│   ├── models/           # Modelos de datos
│   └── widgets/          # Widgets reutilizables
├── assets/               # Recursos estáticos (logo, imágenes)
├── android/              # Configuración plataforma Android
├── ios/                  # Configuración plataforma iOS
└── pubspec.yaml          # Dependencias y metadatos del proyecto
```

---

## Configuración de API / Backend

La app consume la API REST del backend de PastIA mediante el paquete `http`.

| Parámetro         | Valor                                                      |
|-------------------|------------------------------------------------------------|
| **URL base**      | Configurada en `lib/api/constants.dart` → `API_URL = "http://172.17.112.1:3000"` |
| **Autenticación** | Token JWT guardado en `flutter_secure_storage` (clave: `token`) |

Para levantar el backend localmente consulta el [README del backend](https://github.com/proyectos-uaq/API-pastIA/blob/main/README.md).

---

## Contribución

1. Crea una rama: `git checkout -b feature/mi-cambio`
2. Haz commit: `git commit -m "Descripción del cambio"`
3. Push: `git push origin feature/mi-cambio`
4. Abre un **Pull Request**

---

## Licencia

Pendiente de definir.

---

¡Gracias por usar PastIA! 💊
