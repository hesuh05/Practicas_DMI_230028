# Práctica No. 5: Widgets App

**Aplicación de demostración de widgets con Flutter**

## Descripción

Widgets App reúne ejemplos interactivos de componentes y recursos de Flutter en
una sola aplicación. Desde una pantalla principal se puede navegar entre las
demostraciones y cambiar el tema visual.

## Objetivos

- Practicar la composición de interfaces con widgets de Flutter.
- Explorar controles, botones, tarjetas, indicadores y animaciones.
- Implementar navegación entre pantallas con GoRouter.
- Administrar el tema de la aplicación con Riverpod.

## Secciones de la aplicación

- Botones y tarjetas.
- Indicadores de progreso y snackbars.
- Animaciones y controles de interfaz.
- Tutorial y desplazamiento infinito.
- Contador con Riverpod.
- Selector de tema.

## Paquetes principales

| Paquete | Uso |
| --- | --- |
| `go_router` | Navegación entre pantallas. |
| `flutter_riverpod` | Administración del estado y del tema. |
| `animate_do` | Animaciones de interfaz. |

## Configuración y ejecución

Desde la carpeta `practica_05/widgets_app`, instala las dependencias y ejecuta
la aplicación:

```shell
flutter pub get
flutter run
```

## Validación

Desde `practica_05/widgets_app`, ejecuta:

```shell
flutter analyze
flutter test
```

## Arquitectura

El diagrama muestra la estructura de Widgets App y la relación entre sus
pantallas, navegación y administración del tema.

[Abrir diagrama de arquitectura](https://hesuh05.github.io/Practicas_DMI_230028/practica_05/widgets_app/architecture/widgets-app.html) · [Ver archivo fuente](architecture/widgets-app.html)

## Ilustraciones del tutorial
## Capturas de pantalla

<table>
	<tr>
		<td align="center"><img src="../images/home_menu.png" alt="Menú principal" width="180"><br>Menú principal</td>
		<td align="center"><img src="../images/counter_screen_value_8.png" alt="Contador con valor 8" width="180"><br>Contador</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/buttons_screen.png" alt="Demostración de botones" width="180"><br>Botones</td>
		<td align="center"><img src="../images/cards_screen.png" alt="Demostración de tarjetas" width="180"><br>Tarjetas</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/progress_indicators_screen.png" alt="Indicadores de progreso" width="180"><br>Indicadores de progreso</td>
		<td align="center"><img src="../images/snackbars_dialogs_screen.png" alt="Snackbars y diálogos" width="180"><br>Snackbars y diálogos</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/animated_container_screen.png" alt="Widget Animated Container" width="180"><br>Animated Container</td>
		<td align="center"><img src="../images/ui_controls_screen.png" alt="Controles de interfaz" width="180"><br>Controles de interfaz</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/tutorial_final_slide.png" alt="Pantalla final del tutorial" width="180"><br>Tutorial</td>
		<td align="center"><img src="../images/infinite_scroll_loading.png" alt="Carga en desplazamiento infinito" width="180"><br>Desplazamiento infinito</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/theme_changer_purple.png" alt="Selector de tema morado" width="180"><br>Tema morado</td>
		<td align="center"><img src="../images/theme_changer_orange.png" alt="Selector de tema naranja" width="180"><br>Tema naranja</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/theme_changer_pink.png" alt="Selector de tema rosa" width="180"><br>Tema rosa</td>
		<td align="center"><img src="../images/home_menu_brown_theme.png" alt="Menú principal con tema café" width="180"><br>Menú con tema café</td>
	</tr>
</table>
