import 'package:flutter/material.dart';

void main() {
  runApp(const MiTiendaApp());
}

// Modelo de datos para el Producto
class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String categoria; // 'Ropa', 'Chuchería', 'Pan'
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
      // Aseguramos que la ruta inicial esté definida
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaTienda(),
      },
    );
  }
}

class PantallaTienda extends StatefulWidget {
  const PantallaTienda({super.key});

  @override
  State<PantallaTienda> createState() => _PantallaTiendaState();
}

class _PantallaTiendaState extends State<PantallaTienda> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Inventario de ejemplo (Mock Data)
  // En una app real, esto vendría de una base de datos (Supabase)
  final List<Producto> _inventario = [
    // Ropa
    Producto(id: '1', nombre: 'Camiseta Básica', precio: 15.00, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '2', nombre: 'Jeans Clásicos', precio: 35.50, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '3', nombre: 'Gorra Deportiva', precio: 12.00, categoria: 'Ropa', imagenUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?auto=format&fit=crop&w=400&q=80'),
    
    // Chuchería
    Producto(id: '4', nombre: 'Chocolate Barra', precio: 1.50, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1511381939415-e44015466834?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '5', nombre: 'Gomitas Dulces', precio: 0.75, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '6', nombre: 'Papas Fritas', precio: 2.00, categoria: 'Chuchería', imagenUrl: 'https://images.unsplash.com/photo-1566478919030-261443943948?auto=format&fit=crop&w=400&q=80'),
    
    // Pan
    Producto(id: '7', nombre: 'Pan Baguette', precio: 1.20, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '8', nombre: 'Pan de Molde', precio: 2.50, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80'),
    Producto(id: '9', nombre: 'Croissant', precio: 1.80, categoria: 'Pan', imagenUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=400&q=80'),
  ];

  // Estado del carrito: Mapa de ID de producto -> Cantidad
  final Map<String, int> _carrito = {};

  @override
  void initState() {
    super.initState();
    // 4 pestañas: Todo, Ropa, Chuchería, Pan
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Lógica para agregar al carrito
  void _agregarAlCarrito(String id) {
    setState(() {
      _carrito[id] = (_carrito[id] ?? 0) + 1;
    });
  }

  // Lógica para quitar del carrito
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

  // Calcular total
  double _calcularTotal() {
    double total = 0.0;
    _carrito.forEach((id, cantidad) {
      final producto = _inventario.firstWhere((p) => p.id == id);
      total += producto.precio * cantidad;
    });
    return total;
  }

  // Obtener cantidad total de items
  int _cantidadTotalItems() {
    int total = 0;
    _carrito.forEach((_, cantidad) => total += cantidad);
    return total;
  }

  // Widget para construir la lista de productos
  Widget _construirListaProductos(String filtroCategoria) {
    final productosFiltrados = filtroCategoria == 'Todo'
        ? _inventario
        : _inventario.where((p) => p.categoria == filtroCategoria).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        childAspectRatio: 0.75, // Relación de aspecto para que sean más altos que anchos
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: productosFiltrados.length,
      itemBuilder: (context, index) {
        final producto = productosFiltrados[index];
        final cantidadEnCarrito = _carrito[producto.id] ?? 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage(producto.imagenUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Detalles del producto
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Controles de cantidad
                    cantidadEnCarrito == 0
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _agregarAlCarrito(producto.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 0),
                              ),
                              child: const Text('Agregar'),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.red,
                                onPressed: () => _quitarDelCarrito(producto.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Text(
                                '$cantidadEnCarrito',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.green,
                                onPressed: () => _agregarAlCarrito(producto.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
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
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Todo'),
            Tab(icon: Icon(Icons.checkroom), text: 'Ropa'),
            Tab(icon: Icon(Icons.icecream), text: 'Chuchería'),
            Tab(icon: Icon(Icons.bakery_dining), text: 'Pan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _construirListaProductos('Todo'),
          _construirListaProductos('Ropa'),
          _construirListaProductos('Chuchería'),
          _construirListaProductos('Pan'),
        ],
      ),
      // Barra inferior flotante con el total
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_cantidadTotalItems()} artículos',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Total: \$${_calcularTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('COBRAR', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
