# 📱 NaTéraCure Mobile App

Application mobile développée avec **Flutter** pour la plateforme **NaTéraCure (Nature Thérapeutique Cure)**.

NaTéraCure est une application permettant de recenser, consulter et partager des produits thérapeutiques traditionnels à travers une interface moderne, interactive et intuitive.

---

## 🎯 Objectifs

* Faciliter l’accès aux remèdes traditionnels
* Valoriser les connaissances ancestrales
* Offrir une plateforme d’échange entre utilisateurs
* Intégrer des contenus multimédias (images et vidéos)

---

## 🚀 Fonctionnalités principales

### 👤 Authentification

* Inscription
* Connexion
* Déconnexion

---

### 🌿 Produits thérapeutiques

* Consultation des produits
* Affichage détaillé :

  * Nom
  * Maladie traitée
  * Ingrédients
  * Préparation
  * Posologie
  * Précautions

---

### 🎥 Multimédia

* Affichage d’images
* Lecture de vidéos intégrée

---

### ❤️ Interaction sociale

* Like des produits
* Commentaires

---

### 🔍 Recherche

* Recherche par nom
* Recherche par maladie
* Filtrage des contenus

---

## 🛠️ Technologies utilisées

* Flutter
* Dart
* HTTP (requêtes API)
* Provider (gestion d’état)

---

## 📂 Structure du projet

lib/
│
├── main.dart
├── core/
│   ├── constants/
│   ├── utils/
│
├── models/
├── services/
│   └── api_service.dart
│
├── providers/
├── screens/
│   ├── auth/
│   ├── home/
│   ├── product/
│
├── widgets/
└── routes/

---

## ⚙️ Installation

1. Cloner le projet

git clone https://github.com/ton-repo/nateracure

2. Accéder au dossier

cd nateracure-mobile

3. Installer les dépendances

flutter pub get

4. Lancer l’application

flutter run

---

## 🔗 Configuration API

Modifier l’URL de l’API dans le fichier :

lib/core/constants/api.dart

Exemple :

const String baseUrl = "http://localhost:8000/api";

---

## 📱 Génération APK

flutter build apk

---

## 🔐 Permissions requises

* Accès Internet
* Accès stockage (images / vidéos)

---

## 🧪 Tests

flutter test

---

## 📌 Améliorations futures

* Notifications push
* Mode hors ligne
* Chat en temps réel
* Upload direct depuis mobile
* Mode sombre

---

## ⚠️ Avertissement

Les informations disponibles dans l’application sont fournies à titre informatif uniquement et ne remplacent pas un avis médical professionnel.

---

## 👨🏽‍💻 Auteurs

Abdoul Halim Hafiz Adib
Idrissou Bouba
Ngah David Ulrich
Ngathuessi Tagne Stéphane

Projet académique du Developpement mobile

---

# 🌿 NaTéraCure

### La puissance de la nature au service de la santé
