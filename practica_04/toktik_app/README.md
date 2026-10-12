# TokTik

Reproductor vertical de videos implementado en Flutter con separación entre
dominio, infraestructura y presentación.

## Funciones

- Desplazamiento entre **Discover**, **For You** y **Favorites**.
- Fuentes remotas en cascada: Coverr, Pixabay e Internet Archive. Si una fuente
  falla o no ofrece un stream reproducible, se intenta la siguiente.
- Reproducción, pausa/reanudación, silencio y favoritos persistentes.
- Temas automáticos por fecha y selector de temporada para pruebas.
- Selector de fuente persistido: Aleatorio, Coverr, Pixabay, Internet Archive o
  Local. La fuente elegida se intenta primero y conserva el fallback.
- Splash con melodía sintetizada para cada tema.

## Credenciales de APIs

No escribas claves en el código ni en el repositorio. Las variables de
compilación se leen desde `lib/config/api/api_config.dart`:

| Variable de compilación | Servicio | Uso |
| --- | --- | --- |
| `COVERR_API_KEY` | Coverr Videos API | API key para obtener URLs MP4 |
| `PIXABAY_API_KEY` | Pixabay Videos API | Parámetro `key` para búsquedas |
| No requiere clave | Internet Archive API pública | Búsqueda y metadatos de videos |

Ejemplo en Windows:

```powershell
flutter run `
  --dart-define=COVERR_API_KEY=tu_clave_coverr `
  --dart-define=PIXABAY_API_KEY=tu_clave_pixabay
```

Internet Archive no requiere `--dart-define`.

Internet Archive usa búsquedas públicas y después consulta los metadatos de
cada elemento para construir una URL MP4 directa. Si un elemento no contiene
un MP4 compatible, se omite y se intenta otro resultado.

Las claves son opcionales: sin ellas, el repositorio continúa con la siguiente
fuente. Para usar videos locales, agrega MP4 en `assets/videos/` y declara la
carpeta en `pubspec.yaml`.

## Organización

- `lib/domain/`: entidades y contratos.
- `lib/infrastructure/`: APIs, mappers y repositorio con fallback.
- `lib/presentation/`: feeds, controles y navegación.
- `lib/config/`: temas y configuración de APIs.

Ejecuta `flutter analyze` y `flutter test` desde esta carpeta para validar el
proyecto.
