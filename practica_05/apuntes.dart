widgets_app

instalar go_router

borrar todo de main.dart

libs/config
…
menú
menu_items.dart
------
import 'package:flutter/material.dart';

class MenuItem {
	final String title;
	final String subTitle;
	final String link;
	final IconData icon;

	const MenuItem({
		required this.title,
		required this.subTitle,
		required this.link,
		required this.icon
			
	})	
	
}

const appMenuItems = <MenuItem>[
	MenuItem(
		title: 'Botones',
		subTitle: 'Varios botones en Flutter',
		link: '/buttons',
		icon: Icons.smart_button_outlined
	),
	MenuItem(
		title: 'Tarjetas',
		subTitle: 'Un contenedor estilizado',
		link: '/cards',
		icon: Icons.credit_cared
	)
];
-----
router
app_router.dart
-----
import 'package:go_router/go_router.dart';
import 'package:widgets_app/presentation/screens/screens.dart';

// GoRouter Configuration
final appRouter = GoRouter(
	initialLocation: '/',
	routes: [
		GoRoute(
			path: '/',
			name: HomeScreen.name,
			builder: (context, state) => const HomeScreen()
		),
		GoRoute(
			path: '/buttons',
			name: ButtonsScreen.name,
			builder: (context, state) => const HomeScreen()
		),
		GoRoute(
			path: '/cards',
			name: CardsScreen.name,
			builder: (context, state) => const HomeScreen()
		),
	]
);

-----
theme
app_theme.dart
-----
import 'package:flutter/material.dart';

const colorList = <Color> [
	Colors.blue,
	Colors.teal,
	Colors.green,
	Colors.red,
	Colors.purple,
	Colors.deepPurple,
	Colors.orange,
	Colors.pink,
	Colors.pinkAccent
]

class AppTheme {
	final int selectedColor;

	AppTheme({
		this.selectedColor = 0
	}): assert( selectedColor >= 0, 'Selected color must be greater then 0'),
  assert( selectedColor < colorList.length, 'Selected color must be les or equal than ${ colorList.length - 1 }');

	ThemeData getTheme() => ThemeData(
		useMaterial3: true,
		colorSchemeSeed: colorList[ selectedColor ],
		appBarTheme: const AppBarTheme(
      centerTitle: false
    )		
	);
}
-----
main
-----
import 'package:flutter/material.dart';
import 'package:widgets_app/config/app_theme.dart';
import 'package:widgets_app/config/app_router.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}

-----
presentation/screens/home
home_screen.dart
-----
import 'package:flutter/material.dart';
import 'package:go_router/go_router';
import 'package:widgets_app/config/menu/menu_items.dart';
// import 'package:widgets_app/presentation/screens/cards/cards_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Material 3'),
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        return _CustomListTile(menuItem: menuItem);
      }
    )
  }  
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
trailing: const Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {
// Navigator.of(context).push(
// 	MaterialPageRoute(
// 		builder: (context) => const ButtonsScreen(),
// 	),
// );
// Navigator.pushNamed(context, menuItem.link);

// context.pushNamed( CardsScreen.name );
context.push( menuItem.link );
},
);
}
}
        context.push(menuItem.link);
      },
    );
  }
}
-----
lib/presentation/screens
buttons/buttons_screen.dart (1)
cards/cards_screen.dart (2)
-----
1
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonsScreen extends StatelessWidget{
	static const String name = 'buttons_screen';

	const ButtonsScreen({super.key});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Buttons Screen'),
			),
			body: const ButtonsView(),
			floatingActionButton: FloatingActionButton(
				child: const Icon( Icons.arrow_back_ios_new_rounded ),
				onPressed: () {
					context.pop();
				},
			),
		);
	}
}

class _ButtonsView extends StatelessWidget {
	const _ButtonsView();

	@override
	Widget build(BuildContext context){
		final colors = Theme.of(context).colorScheme;
	return SizedBox(
		width: double.infinity,
		child: Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
			child: Wrap(
				spacing: 10,
				aligment: WrapAligment.center,
				children: [
					ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
					const ElevatedButton(onPressed: null, child: Text('Elevated Disabled')),
					ElevatedButton.icon(
						onPressed: (){},
						icon: const Icon( Icons.access_alarm_rounded ),
						label: const Text('Elevated Icon')
					),
					FilledButton(onPressed:(){}, child: const Text('Filled)),
					FilledButton.icon(
						onPressed: (){},
						icon: const Icon( Icons.accessibility_new ),
						label: const Text('Filled Icon'),
					),
					OutlinedButton(onPressed: (){}, child: const Text('Outline)),
					OutlinedButton.icon(
						onPressed: (){},
						label: const Text('Outline Icon'),
						icon: const Icon( Icons.terminal )
					),
					TextButton(onPressed: (){}, child: const Text('Text')),
					TextButton.icon(
						onPressed: (){},
						icon: const Icon( Icons.account_box_outlined ),
						label: const Text('Text Icon'),
					),
					const CustomButton(),
					
					IconButton(onPressed: (){}, icon: const Icon( Icons.app_registration_rounded)),
					IconButton(
						onPressed: (){}
						icon: const Icon( Icons.app_registration_rounded),
						style: ButtonStyle(
							backgroundColor: MaterialStatePropertyAll(colors.primary),
							iconColor: const MaterialStatePropertyAll(Colors.white),
						),
					),
				],
			),
		),
	);}
}

class CustomButton extends StatelessWidget {
	const CustomButton({super.key});

	@override
	Widget build(BuildContext) {
		
		final colors = Theme.of(context).colorScheme;
		
		return ClipRRect(
			borderRadius: BorderRadius.circular(20),
			child: InkWell(
				onTap: (){},
				child: const Padding(
					padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10),
					child: Text('Hola Mundo', style: TextStyle(color: Colors.white))
				),
			),
		),
	}
}
const cards = <Map<String,dynamic>>[
	
]