# Questify

**Questify** transforme la productivite en aventure.
Gerez vos taches comme des **quetes**, gagnez de l'**XP**, montez en **niveau** et rendez vos routines motivantes.

## Stack technique

| Couche | Technologie |
|--------|-------------|
| **Frontend** | Flutter (Dart) — Riverpod, freezed, go_router |
| **Backend** | Spring Boot 3.5 (Java 21) — JWT, JPA/Hibernate, Lombok |
| **Base de donnees** | PostgreSQL 16 |
| **Notifications** | Firebase Cloud Messaging (FCM) |
| **Calendrier** | Google Calendar API v3 |
| **Design** | Figma |

## Architecture

```
questify-app/
├── backend/                  # API REST Spring Boot
│   ├── src/main/java/com/questify/backend/
│   │   ├── auth/             # JWT signup/login/refresh
│   │   ├── user/             # Profil utilisateur, endpoints
│   │   ├── quest/            # CRUD quetes, completion, XP
│   │   ├── xp/               # Systeme XP et niveaux
│   │   ├── notification/     # FCM push, rappels planifies
│   │   ├── calendar/         # Liaison Google Calendar
│   │   └── config/           # Security, CORS, exceptions
│   ├── docker-compose.yml    # PostgreSQL 16 + backend
│   ├── Dockerfile            # Image backend multi-stage
│   └── application.yml       # Configuration
│
├── frontend/                 # App mobile Flutter
│   ├── lib/
│   │   ├── models/           # freezed + json_serializable
│   │   ├── providers/        # Riverpod (auth, quests, stats, calendar, notif)
│   │   ├── services/         # ApiService (HTTP + JWT auto-refresh)
│   │   ├── features/         # Pages (dashboard, quests, profile, settings)
│   │   └── theme.dart        # Theme Material 3 custom
│   └── test/                 # 67 tests (models, providers, widgets)
│
└── README.md
```

## Demarrage rapide

### Pre-requis

- Java 21+ (JDK)
- Flutter SDK 3.10+
- Docker & Docker Compose

### Backend

```bash
cd backend

# Demarrer PostgreSQL
docker compose up -d postgres

# Lancer le backend (port 8080)
./mvnw spring-boot:run
```

Ou tout lancer via Docker :

```bash
cd backend
docker compose up -d --build
```

### Frontend

```bash
cd frontend

# Installer les dependances
dart pub get

# Generer les modeles freezed
dart run build_runner build --delete-conflicting-outputs

# Lancer l'app (emulateur ou device connecte)
flutter run
```

### Tests

```bash
# Backend — 20 tests unitaires
cd backend
./mvnw test

# Frontend — 67 tests
cd frontend
flutter test
```

## Fonctionnalites

- **Authentification JWT** — inscription, connexion, refresh token, stockage securise
- **Gestion des quetes** — creation, modification, completion avec difficulte (Facile/Moyen/Difficile/Epique)
- **Systeme d'XP et niveaux** — gain d'XP a la completion, progression par paliers
- **Dashboard anime** — barre XP animee, stats en temps reel, shimmer loading
- **Profil utilisateur** — niveau, XP, quetes completees
- **Notifications push** — rappels de quetes, notifications level-up (Firebase, optionnel)
- **Google Calendar** — synchronisation des quetes avec Google Agenda
- **Theme Material 3** — mode clair/sombre, animations, transitions

## API endpoints

| Methode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/api/auth/signup` | Inscription |
| POST | `/api/auth/login` | Connexion |
| POST | `/api/auth/refresh` | Refresh token |
| GET | `/api/users/me` | Profil utilisateur |
| PATCH | `/api/users/me` | Modifier profil |
| GET | `/api/users/me/stats` | Stats XP/niveau |
| GET | `/api/quests` | Liste des quetes |
| POST | `/api/quests` | Creer une quete |
| GET | `/api/quests/{id}` | Detail d'une quete |
| PUT | `/api/quests/{id}` | Modifier une quete |
| DELETE | `/api/quests/{id}` | Supprimer une quete |
| PATCH | `/api/quests/{id}/complete` | Completer une quete |
| POST | `/api/calendar/link/{questId}` | Lier un event Google Calendar |
| DELETE | `/api/calendar/link/{questId}` | Delier un event |
| POST | `/api/notifications/register` | Enregistrer un token FCM |
| GET | `/api/notifications/preferences` | Preferences notifications |
| PATCH | `/api/notifications/preferences` | Modifier preferences |

## Variables d'environnement

### Backend (`backend/.env`)

```env
POSTGRES_USER=questify
POSTGRES_PASSWORD=questify
POSTGRES_DB=questify_db
POSTGRES_PORT=5432
POSTGRES_HOST=localhost
```

### Firebase (optionnel)

```env
FIREBASE_ENABLED=true
FIREBASE_CREDENTIALS_PATH=./firebase-service-account.json
```

## Roadmap

- [x] Base du projet
- [x] Authentification utilisateur (JWT)
- [x] Gestion des quetes (CRUD REST)
- [x] Systeme d'XP et niveaux
- [x] Frontend Flutter complet (dashboard, quetes, profil)
- [x] Tests unitaires (87 tests : 20 backend + 67 frontend)
- [x] UI polish, animations, theme Material 3
- [x] Integration Google Calendar + notifications push
- [x] Docker support (PostgreSQL + backend)
- [ ] CI/CD pipeline
- [ ] Configuration Firebase production
- [ ] Publication stores (App Store / Google Play)

## Licence

Code sous MIT, design sous CC BY-NC-SA 4.0.
