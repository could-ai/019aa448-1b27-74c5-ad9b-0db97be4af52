import 'package:flutter/material.dart';

void main() {
  runApp(const MiTiendaApp());
}

// Modelo de datos para el Producto
class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String categoria; // 'Ropa', 'Chuchería', 'Pan', 'Escolar'
  final String imagenUrl;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.imagenUrl,
  });
}

class MiTiendaApp extends StatelessWidget {
  const MiTiendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Tienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaPrincipal(),
      },
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  final List<Widget> _paginas = [
    const VistaTienda(),
    const VistaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: _paginas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Tienda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class VistaTienda extends StatefulWidget {
  const VistaTienda({super.key});

  @override
  State<VistaTienda> createState() => _VistaTiendaState();
}

class _VistaTiendaState extends State<VistaTienda> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Inventario de ejemplo
  final List<Producto> _inventario = [
    // Ropa
    Producto(id: '1', nombre: 'Camiseta', precio: 15.00, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '2', nombre: 'Jeans', precio: 35.50, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '3', nombre: 'Gorra', precio: 12.00, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?auto=format&fit=crop&w=400&q=80'),
    
    // Chuchería
    Producto(id: '4', nombre: 'Chocolate', precio: 1.50, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1511381939415-e44015466834?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '5', nombre: 'Gomitas', precio: 0.75, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '6', nombre: 'Papas', precio: 2.00, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1566478919030-261443943948?auto=format&fit=crop&w=400&q=80'),
    
    // Pan
    Producto(id: '7', nombre: 'Baguette', precio: 1.20, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '8', nombre: 'Pan Molde', precio: 2.50, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '9', nombre: 'Croissant', precio: 1.80, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=400&q=80'),

    // Escolar
    Producto(id: '10', nombre: 'Cuaderno', precio: 3.50, categoria: 'Escolar', imagenUrl: 'https://images.unsplash.com/photo-1531346878377-a513bc950634?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '11', nombre: 'Lápices', precio: 5.00, categoria: 'Escolar', imagenUrl: 'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '12', nombre: 'Mochila', precio: 25.00, categoria: 'Escolar', imagenUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=400&q=80'),
  ];

  // Estado del carrito: Mapa de ID de producto -> Cantidad
  final Map<String, int> _carrito = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _agregarAlCarrito(String id) {
    setState(() {
      _carrito[id] = (_carrito[id] ?? 0) + 1;
    });
  }

  void _quitarDelCarrito(String id) {
    setState(() {
      if (_carrito.containsKey(id) && _carrito[id]! > 0) {
        _carrito[id] = _carrito[id]! - 1;
        if (_carrito[id] == 0) {
          _carrito.remove(id);
        }
      }
    });
  }

  double _calcularTotal() {
    double total = 0.0;
    _carrito.forEach((id, cantidad) {
      final producto = _inventario.firstWhere((p) => p.id == id);
      total += producto.precio * cantidad;
    });
    return total;
  }

  int _cantidadTotalItems() {
    int total = 0;
    _carrito.forEach((_, cantidad) => total += cantidad);
    return total;
  }

  Widget _construirListaProductos(String filtroCategoria) {
    final productosFiltrados = filtroCategoria == 'Todo'
        ? _inventario
        : _inventario.where((p) => p.categoria == filtroCategoria).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columnas para que sean más pequeños
        childAspectRatio: 0.65, // Más altos para acomodar imagen y botones
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: productosFiltrados.length,
      itemBuilder: (context, index) {
        final producto = productosFiltrados[index];
        final cantidadEnCarrito = _carrito[producto.id] ?? 0;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centrar contenido
            children: [
              // Imagen del producto
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    image: DecorationImage(
                      image: NetworkImage(producto.imagenUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Detalles del producto
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centrar texto
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    // Controles de cantidad compactos
                    cantidadEnCarrito == 0
                        ? SizedBox(
                            height: 28,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _agregarAlCarrito(producto.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(fontSize: 11),
                              ),
                              child: const Text('Agregar'),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => _quitarDelCarrito(producto.id),
                                child: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  '$cantidadEnCarrito',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              InkWell(
                                onTap: () => _agregarAlCarrito(producto.id),
                                child: const Icon(Icons.add_circle, color: Colors.green, size: 20),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Tienda'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          tabs: const [
            Tab(icon: Icon(Icons.grid_view, size: 20), text: 'Todo'),
            Tab(icon: Icon(Icons.checkroom, size: 20), text: 'Ropa'),
            Tab(icon: Icon(Icons.icecream, size: 20), text: 'Chuchería'),
            Tab(icon: Icon(Icons.bakery_dining, size: 20), text: 'Pan'),
            Tab(icon: Icon(Icons.school, size: 20), text: 'Escolar'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _construirListaProductos('Todo'),
                _construirListaProductos('Ropa'),
                _construirListaProductos('Chuchería'),
                _construirListaProductos('Pan'),
                _construirListaProductos('Escolar'),
              ],
            ),
          ),
          // Resumen del carrito (ahora parte del cuerpo, no bottomNavigationBar)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_cantidadTotalItems()} items',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        'Total: \$${_calcularTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _cantidadTotalItems() > 0
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('¡Venta Realizada!'),
                                content: Text('Total a cobrar: \$${_calcularTotal().toStringAsFixed(2)}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _carrito.clear();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Nueva Venta'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text('COBRAR', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VistaPerfil extends StatefulWidget {
  const VistaPerfil({super.key});

  @override
  State<VistaPerfil> createState() => _VistaPerfilState();
}

class _VistaPerfilState extends State<VistaPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.account_circle, size: 100, color: Colors.orange),
                const SizedBox(height: 24),
                const Text(
                  'Crear Cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Simulación de registro
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando registro...')),
                      );
                      
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('¡Registro Exitoso!'),
                              content: Text('Bienvenido, ${_nombreController.text}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('REGISTRARSE', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
