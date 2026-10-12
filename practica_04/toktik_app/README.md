# TokTik

Reproductor vertical de videos implementado en Flutter con separación entre
dominio, infraestructura y presentación.

## Funciones

- Desplazamiento lateral entre **Discover**, **For You** y **Favorites**.
- Fuentes remotas en cascada: Pexels, Pixabay y Vimeo. Si una fuente falla o
  no ofrece archivos MP4 reproducibles, se intenta la siguiente; la lista de
  videos locales es el último fallback.
- Reproducción por video, pausa/reanudación por toque o botón y control de
  silencio.
- Me gusta persistentes y colección de favoritos guardados con
  `SharedPreferences`.
- Temas automáticos por fecha: Halloween (30 oct–3 nov), Navidad (5 dic–5 ene)
  y San Valentín (14 feb); los demás días usan el tema normal.
- Selector de temporada y fecha de prueba persistido localmente. Una temporada
  elegida manualmente tiene prioridad sobre la fecha forzada.
- El splash reproduce una breve melodía sintetizada y en bucle para cada tema;
  no requiere archivos de audio adicionales. En Chrome, pulsa `Continuar` si
  el navegador bloquea la reproducción automática.

## Credenciales de APIs

No escribas claves en el código ni en el repositorio. Las variables de
compilación se leen desde
[`lib/config/api/api_config.dart`](lib/config/api/api_config.dart):

| Variable de compilación | Servicio | Uso |
| --- | --- | --- |
| `PEXELS_API_KEY` | Pexels Videos API | Cabecera `Authorization` para el catálogo popular |
| `PIXABAY_API_KEY` | Pixabay Videos API | Parámetro `key` para búsquedas de video |
| `VIMEO_ACCESS_TOKEN` | Vimeo API v3 | Bearer token; el token debe tener acceso al campo `files` para reproducir MP4 |

En Windows, inicia la app pasando las claves que tengas disponibles:

```powershell
flutter run `
  --dart-define=PEXELS_API_KEY=tu_clave_pexels `
  --dart-define=PIXABAY_API_KEY=tu_clave_pixabay `
  --dart-define=VIMEO_ACCESS_TOKEN=tu_token_vimeo
```

Las claves son opcionales: sin ellas, los adaptadores reportan el error y el
repositorio sigue con la siguiente fuente. Para usar el fallback local, agrega
tus archivos MP4 en `assets/videos/` y declara esa carpeta en `pubspec.yaml`;
este repositorio no incluye archivos de video pesados.

## Organización

- `lib/domain/`: entidades, contratos de repositorios y contratos de fuentes
  locales/remotas.
- `lib/infrastructure/`: API HTTP, mappers, almacenamiento de preferencias y
  repositorio con fallback.
- `lib/presentation/`: feeds, controles del reproductor, navegación y ajustes
  de tema.
- `lib/config/`: temas dinámicos y configuración de APIs.

Ejecuta `flutter analyze` y `flutter test` desde esta carpeta para validar el
proyecto.
