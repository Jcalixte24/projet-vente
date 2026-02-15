import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'product_success_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  
  String _selectedCategory = "Bazin";
  final List<String> _categories = ["Bazin", "Sport", "Chaussures", "Accessoires", "Hauts", "Bas"];
  
  // Images
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  // Stock
  int _quantity = 10;
  
  // Options
  final List<String> _sizes = ["S", "M", "L", "XL", "XXL"];
  final Set<String> _selectedSizes = {"S", "L"};
  
  final List<Color> _colors = [Colors.black, Colors.white, Colors.red, Colors.blue];
  Color _selectedColor = Colors.black;


  Future<void> _pickImage() async {
      try {
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
              setState(() {
                  _images.add(image);
              });
          }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007AFF)),
            onPressed: () => Navigator.pop(context),
        ),
        title: const Text("NOUVEAU PRODUIT", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const SectionTitle("PHOTOS DU PRODUIT"),
                const SizedBox(height: 12),
                SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1,
                        itemBuilder: (context, index) {
                            if (index == 0) {
                                return GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                                                SizedBox(height: 4),
                                                Text("Ajouter", style: TextStyle(fontSize: 12, color: Colors.grey))
                                            ],
                                        ),
                                    ),
                                );
                            }
                            final image = _images[index - 1];
                            return Stack(
                                children: [
                                    Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(image: FileImage(File(image.path)), fit: BoxFit.cover)
                                        ),
                                    ),
                                    Positioned(
                                        right: 16,
                                        top: 4,
                                        child: GestureDetector(
                                            onTap: () {
                                                setState(() {
                                                    _images.removeAt(index - 1);
                                                });
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                                            ),
                                        ),
                                    )
                                ],
                            );
                        },
                    ),
                ),
                
                const SizedBox(height: 24),
                
                ProductContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             const Label("NOM DU PRODUIT"),
                             TextField(
                                 controller: _nameController,
                                 decoration: const InputDecoration(
                                     hintText: "Ex: Ensemble Bazin Riche",
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.zero
                                 ),
                             ),
                             const Divider(height: 30),
                             const Label("DESCRIPTION"),
                             TextField(
                                 controller: _descriptionController,
                                 maxLines: 4,
                                 decoration: const InputDecoration(
                                     hintText: "Détails sur la matière, le style...",
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.zero
                                 ),
                             ),
                        ],
                    )
                ),

                const SizedBox(height: 24),
                
                 ProductContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Label("CATÉGORIE"),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: _categories.map((cat) {
                                        final isSelected = cat == _selectedCategory;
                                        return Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: ChoiceChip(
                                                label: Text(cat),
                                                selected: isSelected,
                                                onSelected: (val) {
                                                    setState(() => _selectedCategory = cat);
                                                },
                                                selectedColor: const Color(0xFF007AFF),
                                                labelStyle: TextStyle(
                                                    color: isSelected ? Colors.white : Colors.black87,
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                                                ),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    side: BorderSide(color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade300)
                                                ),
                                            ),
                                        );
                                    }).toList(),
                                ),
                            )
                        ],
                    )
                ),

                const SizedBox(height: 24),
                
                Row(
                    children: [
                        Expanded(
                            child: ProductContainer(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Label("PRIX DE VENTE (FCFA)"),
                                        TextField(
                                            controller: _priceController,
                                            keyboardType: TextInputType.number,
                                             decoration: const InputDecoration(
                                                hintText: "25000",
                                                border: InputBorder.none,
                                            ),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        )
                                    ],
                                ),
                            ),
                        ),
                        const SizedBox(width: 16),
                         Expanded(
                            child: ProductContainer(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Label("PRIX BARRÉ (OPTIONAL)"),
                                        TextField(
                                            controller: _oldPriceController,
                                            keyboardType: TextInputType.number,
                                             decoration: const InputDecoration(
                                                hintText: "30000", 
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(color: Colors.grey)
                                            ),
                                            style: const TextStyle(color: Colors.grey, fontSize: 16, decoration: TextDecoration.lineThrough),
                                        )
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),

                const SizedBox(height: 24),
                
                 ProductContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Label("TAILLES DISPONIBLES"),
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 8,
                                children: _sizes.map((size) {
                                    final isSelected = _selectedSizes.contains(size);
                                    return GestureDetector(
                                        onTap: () {
                                            setState(() {
                                                if (isSelected) {
                                                    _selectedSizes.remove(size);
                                                } else {
                                                    _selectedSizes.add(size);
                                                }
                                            });
                                        },
                                        child: Container(
                                            width: 40, height: 40,
                                            decoration: BoxDecoration(
                                                color: isSelected ? const Color(0xFF007AFF) : Colors.white,
                                                border: Border.all(color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            child: Center(
                                                child: Text(size, style: TextStyle(
                                                    color: isSelected ? Colors.white : Colors.black87,
                                                    fontWeight: FontWeight.bold
                                                )),
                                            ),
                                        ),
                                    );
                                }).toList(),
                            ),
                            const Divider(height: 30),
                             const Label("COULEURS"),
                              const SizedBox(height: 12),
                              Row(
                                  children: [
                                      ..._colors.map((color) => GestureDetector(
                                          onTap: () => setState(() => _selectedColor = color),
                                          child: Container(
                                              margin: const EdgeInsets.only(right: 12),
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: _selectedColor == color ? const Color(0xFF007AFF) : Colors.transparent, width: 2) 
                                              ),
                                              child: Container(
                                                  width: 32, height: 32,
                                                  decoration: BoxDecoration(
                                                      color: color,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.grey.shade300)
                                                  ),
                                                  child: _selectedColor == color && color == Colors.white 
                                                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                                                  : _selectedColor == color 
                                                  ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                              ),
                                          ),
                                      )).toList(),
                                      Container(
                                          width: 32, height: 32,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.add, size: 16, color: Colors.grey),
                                      )
                                  ],
                              )
                        ],
                    ),
                 ),

                 const SizedBox(height: 24),
                 
                  ProductContainer(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              const Label("QUANTITÉ EN STOCK"),
                              Row(
                                  children: [
                                      IconButton(onPressed: () => setState(() => _quantity = _quantity > 0 ? _quantity - 1 : 0), icon: const Icon(Icons.remove)),
                                      Text("$_quantity", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add)),
                                  ],
                              )
                          ],
                      ),
                  ),

                   const SizedBox(height: 32),
                   
                   SizedBox(
                       width: double.infinity,
                       height: 56,
                       child: ElevatedButton(
                           onPressed: () {
                               // Simulate successful upload
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProductSuccessScreen()),
                               );
                           },
                           style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF007AFF),
                               foregroundColor: Colors.white,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                               elevation: 5
                           ),
                           child: const Text("Publier le produit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                       ),
                   ),

                   const SizedBox(height: 24),
                   const Center(
                       child: Text(
                           "En publiant ce produit, il sera immédiatement visible\nsur votre boutique.",
                           textAlign: TextAlign.center,
                           style: TextStyle(color: Colors.grey, fontSize: 12),
                       ),
                   ),
                   const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
    final String title;
    const SectionTitle(this.title, {super.key});
    @override
    Widget build(BuildContext context) {
        return Text(title, style: TextStyle(color: Colors.blue[300], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0));
    }
}

class ProductContainer extends StatelessWidget {
    final Widget child;
    const ProductContainer({required this.child, super.key});
    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
            ),
            child: child,
        );
    }
}

class Label extends StatelessWidget {
    final String text;
    const Label(this.text, {super.key});
    @override
    Widget build(BuildContext context) {
        return Text(text, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold));
    }
}
