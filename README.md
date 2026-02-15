lib/
├── config/                  # Les réglages globaux
│   ├── theme.dart           # Tes couleurs (Violet), polices
│   └── constants.dart       # Textes fixes, clés API
│
├── models/                  # Les "Patrons" de données (La structure)
│   ├── user_model.dart      # id, phone, nom...
│   ├── product_model.dart   # id, prix, image...
│   └── cart_item_model.dart # produit + quantité
│
├── screens/                 # Les pages complètes
│   ├── auth/                # Dossier Authentification
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/                # Dossier Accueil
│   │   └── home_screen.dart
│   ├── product/             # Dossier Produit
│   │   └── product_detail_screen.dart
│   ├── cart/                # Dossier Panier & Caisse
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   └── admin/               # Dossier Administrateur (Back-office)
│       └── add_product_screen.dart
│
├── widgets/                 # Les petits bouts réutilisables
│   ├── common/              # Boutons, Champs de texte
│   │   ├── custom_button.dart
│   │   └── custom_textfield