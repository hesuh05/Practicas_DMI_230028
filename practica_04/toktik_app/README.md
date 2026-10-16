# Práctica 04: TokTik

**Aplicación de reproducción de videos verticales**

**Valor:** 30 firmas

TokTik es una aplicación móvil desarrollada con Flutter que simula la
experiencia de una red social de videos cortos. Permite recorrer videos con
desplazamiento vertical y organiza la aplicación mediante principios de
arquitectura CLEAN, separando presentación, dominio e infraestructura.

## Objetivo

Construir una aplicación básica de reproducción de videos verticales y aplicar
widgets con y sin estado, administración de estado, consumo de servicios,
persistencia local y separación de responsabilidades.

Durante la práctica se utilizan:

- Widgets `StatelessWidget` y `StatefulWidget`.
- Providers para compartir y actualizar el estado de la aplicación.
- Manejo de assets y paquetes de Flutter.
- `GestureDetector` y posicionamiento de widgets.
- Mappers para convertir respuestas externas a modelos de dominio.
- Gradientes, loops y aserciones.
- `Stack` para superponer controles sobre el video.
- Controladores de video para reproducción, pausa y sonido.
- Principios de arquitectura CLEAN.

## Funcionalidades

- **Feeds:** secciones **Discover**, **For You** y **Favorites**, con navegación
  entre secciones y desplazamiento vertical para recorrer los videos.
- **Fuentes de video:** consulta de tres fuentes remotas: Coverr, Pixabay e
  Internet Archive. El repositorio intenta la fuente seleccionada primero y
  continúa con las demás cuando una falla o no ofrece un video reproducible.
  También contempla videos locales.
- **Reproducción y sonido:** reproducción y pausa/reanudación de videos, además
  de activar o silenciar el audio desde el control de sonido en la columna de
  acciones.
- **Me gusta y favoritos:** los cambios en el estado de favorito actualizan el
  contador de me gusta y se guardan localmente. Al desmarcar el corazón se resta
  el me gusta; al marcarlo de nuevo, se suma.
- **Descripción:** presentación de descripciones extensas con opción de
  expandir el texto cuando excede el límite visible; el área de descripción
  permite desplazamiento vertical.
- **Temas de temporada:** temas Normal, Halloween, Navidad y San Valentín,
  aplicados automáticamente de acuerdo con la fecha del dispositivo. Incluyen
  paletas de color, iconografía, tipografía y audio.
- **Pruebas de tema:** selector para elegir manualmente cualquier temporada,
  guardado en el almacenamiento local para facilitar las pruebas.
- **Fuente de video:** selector persistente para usar una fuente aleatoria,
  Coverr, Pixabay, Internet Archive o videos locales.

La persistencia local se conserva mientras los datos de la aplicación no se
borren; no sustituye una cuenta ni una sincronización entre dispositivos.

## Paquetes principales

| Paquete | Uso |
| --- | --- |
| `provider` | Administración y distribución del estado. |
| `video_player` | Reproducción y control de videos. |
| `http` | Solicitudes a las APIs de video. |
| `shared_preferences` | Preferencias y datos persistidos localmente. |
| `audioplayers` | Audio asociado a los temas de temporada. |
| `intl` | Utilidades de fechas y formatos. |
| `animate_do` | Animaciones de interfaz. |

## Configuración y ejecución

Instala las dependencias desde la carpeta `practica_04/toktik_app`:

```shell
flutter pub get
```

Coverr y Pixabay utilizan claves opcionales. No incluyas claves en el código ni
en el repositorio; configúralas como variables de compilación, leídas desde
`lib/config/api/api_config.dart`:

| Variable | Servicio | Uso |
| --- | --- | --- |
| `COVERR_API_KEY` | Coverr Videos API | Obtener URLs de video MP4. |
| `PIXABAY_API_KEY` | Pixabay Videos API | Buscar videos. |
| No requiere clave | Internet Archive API pública | Buscar videos y consultar sus metadatos. |

Ejemplo de ejecución en Windows PowerShell:

```powershell
flutter run `
  --dart-define=COVERR_API_KEY=tu_clave_coverr `
  --dart-define=PIXABAY_API_KEY=tu_clave_pixabay
```

Internet Archive no requiere clave. La aplicación consulta los metadatos de
cada elemento para localizar un MP4 directo; si no hay uno compatible, omite
ese elemento y prueba otro. Si una clave no está configurada o una fuente falla,
el repositorio continúa con las fuentes disponibles.

Para probar videos locales, agrega archivos MP4 en `assets/videos/` y declara
esa carpeta en `pubspec.yaml`.

## Validación

Desde `practica_04/toktik_app`, ejecuta:

```shell
flutter analyze
flutter test
```

## Arquitectura

- `lib/presentation/`: pantallas, feeds, navegación, controles y estado de la
  interfaz.
- `lib/domain/`: entidades y contratos que definen las operaciones de la
  aplicación sin depender de servicios externos.
- `lib/infrastructure/`: datasources, consumo de APIs, mappers y repositorios.
- `lib/config/`: configuración de APIs y temas visuales/auditivos.
- `lib/assets/`: recursos visuales y audios de temporada.

La práctica documenta dos diagramas: la propuesta inicial con provider local y
la arquitectura final con provider conectado al repositorio y a los distintos
datasources.

| Diagrama | GitHub Pages | Archivo fuente |
| --- | --- | --- |
| Arquitectura inicial: provider local | [Abrir diagrama inicial](https://hesuh05.github.io/Practicas_DMI_230028/practica_04/toktik_app/architecture/initial/architecture.html) | [architecture/initial/architecture.html](architecture/initial/architecture.html) |
| Arquitectura final: provider, repositorio y datasources | [Abrir diagrama final](https://hesuh05.github.io/Practicas_DMI_230028/practica_04/toktik_app/architecture/final/architecture.html) | [architecture/final/architecture.html](architecture/final/architecture.html) |

[Appetize](https://appetize.io/app/b_awtvwes557nk2jqtbaqodswnqq?device=pixel7&osVersion=13.0&toolbar=true)