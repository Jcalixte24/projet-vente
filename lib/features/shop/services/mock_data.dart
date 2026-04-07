import '../models/models.dart';

// ─── DONNÉES MOCK — MarketCI ──────────────────────────────────────────────────
// Toutes les données fictives réalistes pour le front ivoirien.

class MockData {
  // ── Produits ────────────────────────────────────────────────────────────────
  static final List<Product> products = [
    Product(
      id: 'p001',
      name: 'Robe Bazin Riche Dorée',
      description:
          'Magnifique robe en bazin riche avec broderies dorées. Tissu importé du Mali, idéal pour les mariages et baptêmes. Entretien : lavage à la main à l'eau froide.',
      price: 28000,
      originalPrice: 35000,
      images: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1594938298603-c8148c47e356?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Femmes',
      shopId: 's001',
      shopName: 'CASA BISMARK',
      rating: 4.8,
      reviewCount: 142,
      stock: 5,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Or', 'Bleu Royal', 'Rouge'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Product(
      id: 'p002',
      name: 'Sneakers Air Run V2',
      description:
          'Sneakers dernière génération, semelle en caoutchouc vulcanisé. Légères et respirantes, parfaites pour le quotidien abidjanais. Disponibles en pointures 40 à 46.',
      price: 25000,
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Hommes',
      shopId: 's002',
      shopName: 'BOBSPORT CI',
      rating: 4.5,
      reviewCount: 89,
      stock: 12,
      sizes: ['40', '41', '42', '43', '44', '45', '46'],
      colors: ['Blanc', 'Noir', 'Bleu'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Product(
      id: 'p003',
      name: 'Sac à Main Cuir Végan',
      description:
          'Sac à main en cuir végétalien de qualité supérieure. Fabriqué artisanalement à Abidjan. Fermeture éclair YKK, bandoulière amovible.',
      price: 18500,
      originalPrice: 22000,
      images: [
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Accessoires',
      shopId: 's003',
      shopName: 'LUXE CI',
      rating: 4.7,
      reviewCount: 63,
      stock: 8,
      sizes: [],
      colors: ['Camel', 'Noir', 'Bordeaux'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Product(
      id: 'p004',
      name: 'Chemise en Lin Casual',
      description:
          'Chemise 100% lin, coupe décontractée pour l'homme moderne. Respirante et légère, parfaite sous le soleil ivoirien. Disponible en plusieurs couleurs.',
      price: 8000,
      originalPrice: 10000,
      images: [
        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1604695573706-53170668f6a6?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Hommes',
      shopId: 's001',
      shopName: 'CASA BISMARK',
      rating: 4.3,
      reviewCount: 211,
      stock: 30,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Blanc', 'Beige', 'Bleu Ciel'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    Product(
      id: 'p005',
      name: 'Costume Slim Fit Anthracite',
      description:
          'Costume 2 pièces en tissu stretch, coupe slim fit. Idéal pour les réunions d'affaires et événements formels. Livré avec le pantalon assorti.',
      price: 45000,
      images: [
        'https://images.unsplash.com/photo-1621072118058-19e5b2b4f80e?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1594938298603-c8148c47e356?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Hommes',
      shopId: 's004',
      shopName: 'ÉLÉGANCE ABIDJAN',
      rating: 4.9,
      reviewCount: 34,
      stock: 4,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Anthracite', 'Marine', 'Noir'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: 'p006',
      name: 'Ensemble Wax Ankara Festif',
      description:
          'Ensemble 2 pièces (haut + jupe) en wax 100% coton Ankara. Teinture naturelle, couleurs vibrantes qui ne déteint pas. Couture locale Abidjan.',
      price: 15000,
      images: [
        'https://images.unsplash.com/photo-1590735213920-68192a487bc2?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Femmes',
      shopId: 's005',
      shopName: 'WAX & COULEURS',
      rating: 4.6,
      reviewCount: 178,
      stock: 0,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Multicolore Orange', 'Multicolore Bleu', 'Rouge/Jaune'],
      isAvailable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Product(
      id: 'p007',
      name: 'Sandales Cuir Artisanales',
      description:
          'Sandales fabriquées par des artisans locaux de Korhogo. Cuir véritable tanné à l'ancienne. Semelle en caoutchouc naturel, très confortables.',
      price: 7500,
      originalPrice: 9000,
      images: [
        'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Accessoires',
      shopId: 's006',
      shopName: 'ARTISAN NORD CI',
      rating: 4.4,
      reviewCount: 55,
      stock: 20,
      sizes: ['38', '39', '40', '41', '42', '43', '44'],
      colors: ['Marron Naturel', 'Noir'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: 'p008',
      name: 'T-shirt Premium Oversize',
      description:
          'T-shirt 100% coton peigné, coupe oversize tendance. Sérigraphie haute définition, ne se déforme pas au lavage. Idéal pour le streetwear abidjanais.',
      price: 5500,
      images: [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Hommes',
      shopId: 's002',
      shopName: 'BOBSPORT CI',
      rating: 4.2,
      reviewCount: 302,
      stock: 50,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Blanc', 'Noir', 'Gris', 'Vert Kaki'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: 'p009',
      name: 'Robe Enfant Wax Festive',
      description:
          'Adorable robe en wax pour les petites filles de 3 à 12 ans. Parfaite pour les fêtes, baptêmes et sorties. Tissu doux et respirant.',
      price: 6000,
      images: [
        'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Enfants',
      shopId: 's005',
      shopName: 'WAX & COULEURS',
      rating: 4.8,
      reviewCount: 91,
      stock: 15,
      sizes: ['3-4 ans', '5-6 ans', '7-8 ans', '9-10 ans', '11-12 ans'],
      colors: ['Rose/Or', 'Bleu/Blanc', 'Vert/Jaune'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Product(
      id: 'p010',
      name: 'Montre Chronographe Homme',
      description:
          'Montre chronographe avec cadran soleillé, bracelet en acier inoxydable. Étanche à 50m, mouvement à quartz japonais. Garantie 2 ans.',
      price: 35000,
      originalPrice: 42000,
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?auto=format&fit=crop&q=80&w=600',
      ],
      category: 'Accessoires',
      shopId: 's003',
      shopName: 'LUXE CI',
      rating: 4.6,
      reviewCount: 47,
      stock: 6,
      sizes: [],
      colors: ['Argent/Blanc', 'Or/Noir', 'Noir/Noir'],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  // ── Produits vedettes (featured) ────────────────────────────────────────────
  static List<Product> get featuredProducts =>
      products.where((p) => p.hasDiscount && p.isAvailable).toList();

  // ── Best sellers ────────────────────────────────────────────────────────────
  static List<Product> get bestSellers {
    final sorted = [...products];
    sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return sorted.take(6).toList();
  }

  // ── Nouveautés ───────────────────────────────────────────────────────────────
  static List<Product> get newArrivals {
    final sorted = [...products];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(6).toList();
  }

  // ── Utilisateur connecté (mock) ──────────────────────────────────────────────
  static final AppUser currentUser = AppUser(
    id: 'u001',
    firstName: 'Jean-Baptiste',
    lastName: 'Kouassi',
    phone: '+225 07 12 34 56 78',
    email: 'jb.kouassi@gmail.com',
    defaultAddress: 'Derrière la pharmacie Bonheur, immeuble bleu, 3ème étage',
    defaultZone: 'abj-centre',
    isSeller: false,
    createdAt: DateTime(2024, 6, 15),
  );

  // ── Commandes (mock) ─────────────────────────────────────────────────────────
  static final List<Order> orders = [
    Order(
      id: 'CMD-2025-0042',
      userId: 'u001',
      items: [
        const OrderItem(
          productId: 'p001',
          productName: 'Robe Bazin Riche Dorée',
          productImage:
              'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=300',
          price: 28000,
          quantity: 1,
          selectedSize: 'M',
          selectedColor: 'Or',
        ),
      ],
      status: OrderStatus.shipped,
      subtotal: 28000,
      deliveryFee: 1500,
      total: 29500,
      deliveryZone: 'abj-centre',
      deliveryAddress: 'Cocody Angré, derrière la pharmacie Bonheur',
      paymentMethod: 'wave',
      paymentPhone: '+225 01 23 45 67 89',
      transactionId: 'WAVE-2025-78KL',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      estimatedDelivery: DateTime.now().add(const Duration(hours: 4)),
      statusHistory: [
        OrderStatusUpdate(
          status: OrderStatus.pending,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
        OrderStatusUpdate(
          status: OrderStatus.preparing,
          timestamp: DateTime.now().subtract(const Duration(hours: 20)),
          note: 'Votre colis est en cours de préparation',
        ),
        OrderStatusUpdate(
          status: OrderStatus.shipped,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          note: 'Le livreur Koné a récupéré votre colis',
        ),
      ],
    ),
    Order(
      id: 'CMD-2025-0031',
      userId: 'u001',
      items: [
        const OrderItem(
          productId: 'p004',
          productName: 'Chemise en Lin Casual',
          productImage:
              'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=300',
          price: 8000,
          quantity: 2,
          selectedSize: 'L',
          selectedColor: 'Beige',
        ),
        const OrderItem(
          productId: 'p007',
          productName: 'Sandales Cuir Artisanales',
          productImage:
              'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=300',
          price: 7500,
          quantity: 1,
          selectedSize: '42',
          selectedColor: 'Marron Naturel',
        ),
      ],
      status: OrderStatus.delivered,
      subtotal: 23500,
      deliveryFee: 2000,
      total: 25500,
      deliveryZone: 'abj-sud',
      deliveryAddress: 'Marcory Zone 4, résidence Les Flamboyants',
      paymentMethod: 'orange',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      statusHistory: [
        OrderStatusUpdate(
          status: OrderStatus.pending,
          timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 1)),
        ),
        OrderStatusUpdate(
          status: OrderStatus.preparing,
          timestamp: DateTime.now().subtract(const Duration(days: 9, hours: 14)),
        ),
        OrderStatusUpdate(
          status: OrderStatus.shipped,
          timestamp: DateTime.now().subtract(const Duration(days: 9, hours: 6)),
        ),
        OrderStatusUpdate(
          status: OrderStatus.delivered,
          timestamp: DateTime.now().subtract(const Duration(days: 8, hours: 16)),
          note: 'Livraison effectuée avec succès',
        ),
      ],
    ),
  ];

  // ── Notifications (mock) ─────────────────────────────────────────────────────
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n001',
      title: '🚚 Commande en route !',
      body: 'Votre commande CMD-2025-0042 est en cours de livraison. Le livreur arrivera dans ~4h.',
      type: 'order',
      orderId: 'CMD-2025-0042',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'n002',
      title: '🎉 Soldes en cours !',
      body: 'Jusqu\'à -40% sur la mode féminine. Profitez-en avant le stock épuisé !',
      type: 'promo',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AppNotification(
      id: 'n003',
      title: '✅ Paiement confirmé',
      body: 'Votre paiement Wave de 29 500 FCFA pour la commande CMD-2025-0042 a bien été reçu.',
      type: 'payment',
      orderId: 'CMD-2025-0042',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    AppNotification(
      id: 'n004',
      title: '📦 Commande livrée',
      body: 'Votre commande CMD-2025-0031 a été livrée. Satisfait ? Notez votre achat !',
      type: 'order',
      orderId: 'CMD-2025-0031',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 8, hours: 16)),
    ),
  ];

  // ── Codes promo (mock) ───────────────────────────────────────────────────────
  static const Map<String, double> promoCodes = {
    'BIENVENUE10': 0.10,  // -10%
    'SOLDES20': 0.20,     // -20%
    'FETE15': 0.15,       // -15%
    'VIPCI': 0.25,        // -25% (VIP)
  };

  // ── Recherches suggérées ──────────────────────────────────────────────────────
  static const List<String> searchSuggestions = [
    'Robe bazin',
    'Sneakers homme',
    'Wax femme',
    'Sac cuir',
    'Ensemble bogolan',
    'Sandales artisanales',
    'Costume bureau',
  ];
}
