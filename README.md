# Flutter E-commerce App - Frontend v1

Une application e-commerce mobile-first conçue pour le marché ivoirien, avec une interface utilisateur moderne et une expérience fluide pour les acheteurs et les vendeurs.

## 🚀 Fonctionnalités (Frontend v1)

### 🛍️ Pour les Acheteurs
- **Navigation Intuitive** : Accueil avec catégories, bannières promotionnelles et produits en vedette.
- **Liste des Boutiques** : Annuaire des boutiques partenaires avec filtres par catégorie.
- **Détails Produit** : Carrousel d'images, sélection de taille/couleur, et description extensible.
- **Panier Optimisé** : Regroupement des articles par vendeur, code promo, et estimation des frais de livraison.
- **Validation de Commande** : Parcours de commande en 2 étapes (Livraison & Paiement) avec support des moyens de paiement locaux (Wave, Orange Money, MTN, etc.).

### 🏪 Pour les Vendeurs (Dashboard)
- **Tableau de Bord** : Vue d'ensemble des ventes et statistiques clés.
- **Gestion des Commandes** : Suivi des commandes (En attente, En préparation, Livré).
- **Gestion du Stock** : Inventaire complet avec filtres (En stock, Rupture, Archivés) et mise à jour rapide.
- **Profil Boutique** : Gestion des informations de la boutique, horaires et zones de livraison.
- **Ajout de Produit** : Formulaire complet pour ajouter de nouveaux articles.

## 🛠️ Stack Technique
- **Framework** : Flutter (Dart)
- **Architecture** : Feature-based folder structure
- **State Management** : Provider
- **UI** : Material Design 3 avec une palette de couleurs personnalisée (Violet/Vert).

## � Architecture du Projet

Le projet suit une architecture **Feature-First** (par fonctionnalité) pour une meilleure scalabilité :

```
lib/
├── config/             # Configuration globale (Thèmes, Constants)
├── features/           # Fonctionnalités modules
│   ├── admin/          # Gestion vendeurs (Dashboard, Stock, Commandes)
│   ├── auth/           # Authentification (Login, Signup)
│   ├── shop/           # Boutique client (Accueil, Panier, Checkout)
│   └── shared/         # Widgets et modèles partagés
├── main.dart           # Point d'entrée
└── ...
```

## �📦 Installation

1.  Cloner le dépôt :
    ```bash
    git clone https://github.com/votre-repo/flutter-ecommerce.git
    ```
2.  Installer les dépendances :
    ```bash
    flutter pub get
    ```
3.  Lancer l'application :
    ```bash
    flutter run -d chrome
    ```

## 📝 Auteur
*