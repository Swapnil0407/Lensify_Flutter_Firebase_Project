# Lenscart – StatefulWidget + Navigation Report

Generated: 2026-01-07

> Scope note: “when touch which file is opened” is interpreted as **navigation** (route changes / screen opens). This report does **not** list non-navigation taps (e.g., toggling password visibility), except where helpful.

---

## 1) App routes (named routes)

From [lib/main.dart](../lib/main.dart)

| Route | Opens widget | File |
|---|---|---|
| `/splash` | `SplashScreen` | [lib/Screens/SplashScreen.dart](../lib/Screens/SplashScreen.dart) |
| `/login` | `loginScreen` | [lib/Screens/LoginScreen.dart](../lib/Screens/LoginScreen.dart) |
| `/signup` | `signUpScreen` | [lib/Screens/SignUpScreen.dart](../lib/Screens/SignUpScreen.dart) |
| `/home` | `MainNavScreen(initialIndex: 0)` | [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart) |
| `/orders` | `MainNavScreen(initialIndex: 1)` | [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart) |
| `/cart` | `MainNavScreen(initialIndex: 2)` | [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart) |
| `/profile` | `MainNavScreen(initialIndex: 3)` | [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart) |
| `/favorites` | `FavoritesScreen` | [lib/Screens/FavoritesScreen.dart](../lib/Screens/FavoritesScreen.dart) |
| `/eyeglasses/men` | `EyeglassMen` | [lib/Screens/EyeGlasses/EyglassesMen.dart](../lib/Screens/EyeGlasses/EyglassesMen.dart) |
| `/eyeglasses/women` | `EyeglassWomen` | [lib/Screens/EyeGlasses/EyglassesWomen.dart](../lib/Screens/EyeGlasses/EyglassesWomen.dart) |
| `/eyeglasses/kids` | `EyeglassKids` | [lib/Screens/EyeGlasses/EyglassesKids.dart](../lib/Screens/EyeGlasses/EyglassesKids.dart) |
| `/sunglasses/men` | `SunglassMen` | [lib/Screens/SunGlasses/SunglassesMen.dart](../lib/Screens/SunGlasses/SunglassesMen.dart) |
| `/sunglasses/women` | `SunglassWomen` | [lib/Screens/SunGlasses/SunglassesWomen.dart](../lib/Screens/SunGlasses/SunglassesWomen.dart) |
| `/sunglasses/kids` | `SunglassKids` | [lib/Screens/SunGlasses/SunglassesKids.dart](../lib/Screens/SunGlasses/SunglassesKids.dart) |

---

## 2) All StatefulWidget names (inventory)

Detected by searching `class … extends StatefulWidget`.

| StatefulWidget | File | Purpose | Responsive? |
|---|---|---|---|
| `SplashScreen` | [lib/Screens/SplashScreen.dart](../lib/Screens/SplashScreen.dart) | Shows splash image and auto-navigates to Login after timer. | Partial (full-screen image uses `SizedBox.expand`, but no breakpoints) |
| `loginScreen` | [lib/Screens/LoginScreen.dart](../lib/Screens/LoginScreen.dart) | Login UI and navigation to Home/Signup. | **Yes** (uses `MediaQuery.viewInsets.bottom` to pad for keyboard) |
| `signUpScreen` | [lib/Screens/SignUpScreen.dart](../lib/Screens/SignUpScreen.dart) | Signup UI and navigation to Home/Login. | **Yes** (uses `MediaQuery.viewInsets.bottom` to pad for keyboard) |
| `MainNavScreen` | [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart) | Bottom navigation shell using `IndexedStack`. | Partial (standard Flutter layout; no adaptive rules) |
| `homeScreen` | [lib/Screens/HomeScreen.dart](../lib/Screens/HomeScreen.dart) | Home page: banners + category tiles that open the shape picker. | Partial (scroll view works on sizes; many fixed widths/heights) |
| `ProfileScreen` | [lib/Screens/ProfileScreen.dart](../lib/Screens/ProfileScreen.dart) | Buyer/Seller mode; seller CRUD; buyer “Orders”; logout. | Partial |
| `SellerAddProductScreen` | [lib/Screens/SellerAddProductScreen.dart](../lib/Screens/SellerAddProductScreen.dart) | Seller add/edit product form. | Partial (scroll form; no explicit breakpoints) |
| `EyeglassMen` | [lib/Screens/EyeGlasses/EyglassesMen.dart](../lib/Screens/EyeGlasses/EyglassesMen.dart) | Men eyeglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `EyeglassWomen` | [lib/Screens/EyeGlasses/EyglassesWomen.dart](../lib/Screens/EyeGlasses/EyglassesWomen.dart) | Women eyeglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `EyeglassKids` | [lib/Screens/EyeGlasses/EyglassesKids.dart](../lib/Screens/EyeGlasses/EyglassesKids.dart) | Kids eyeglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `SunglassMen` | [lib/Screens/SunGlasses/SunglassesMen.dart](../lib/Screens/SunGlasses/SunglassesMen.dart) | Men sunglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `SunglassWomen` | [lib/Screens/SunGlasses/SunglassesWomen.dart](../lib/Screens/SunGlasses/SunglassesWomen.dart) | Women sunglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `SunglassKids` | [lib/Screens/SunGlasses/SunglassesKids.dart](../lib/Screens/SunGlasses/SunglassesKids.dart) | Kids sunglasses: 4 shape tiles. | Not really (fixed 150×150 tiles) |
| `FramePurchaseSheet` | [lib/Screens/PurchaseSheets/shared/frame_purchase_sheet.dart](../lib/Screens/PurchaseSheets/shared/frame_purchase_sheet.dart) | Bottom sheet purchase UI (options, qty, add-to-cart, buy-now). | **Yes** (pads bottom using `MediaQuery.viewInsets.bottom`) |

Extra note: Some screens are `StatelessWidget` but still “responsive-ish”, e.g. `ProductDetailsScreen` uses `AspectRatio` for the image in [lib/Screens/ProductDetailsScreen.dart](../lib/Screens/ProductDetailsScreen.dart).

---

## 3) Touch → Opens which screen/file (navigation map)

### A) Splash flow

- `SplashScreen` (in [lib/Screens/SplashScreen.dart](../lib/Screens/SplashScreen.dart))
  - After 3 seconds → `Navigator.pushReplacementNamed("/login")` → opens `loginScreen` in [lib/Screens/LoginScreen.dart](../lib/Screens/LoginScreen.dart)

### B) Login / Signup

- `loginScreen` (in [lib/Screens/LoginScreen.dart](../lib/Screens/LoginScreen.dart))
  - Tap **LOGIN** button → `Navigator.pushReplacementNamed("/home")` → opens `MainNavScreen(initialIndex: 0)` in [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart)
  - Tap **Sign Up** text → `Navigator.pushNamed("/signup")` → opens `signUpScreen` in [lib/Screens/SignUpScreen.dart](../lib/Screens/SignUpScreen.dart)

- `signUpScreen` (in [lib/Screens/SignUpScreen.dart](../lib/Screens/SignUpScreen.dart))
  - Tap **SIGN UP** button → `Navigator.pushReplacementNamed("/home")` → opens `MainNavScreen(initialIndex: 0)` in [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart)
  - Tap **Login** text → `Navigator.pushNamed("/login")` → opens `loginScreen` in [lib/Screens/LoginScreen.dart](../lib/Screens/LoginScreen.dart)

### C) Bottom navigation (main shell)

- `MainNavScreen` (in [lib/Screens/MainNavScreen.dart](../lib/Screens/MainNavScreen.dart))
  - Tapping bottom navbar items changes tab **without pushing routes** (it updates `_index` in an `IndexedStack`).
  - Tab mapping:
    - Index `0` → `homeScreen` in [lib/Screens/HomeScreen.dart](../lib/Screens/HomeScreen.dart)
    - Index `1` → `OrdersScreen` in [lib/Screens/OrdersScreen.dart](../lib/Screens/OrdersScreen.dart)
    - Index `2` → `CartScreen` in [lib/Screens/CartScreen.dart](../lib/Screens/CartScreen.dart)
    - Index `3` → `ProfileScreen` in [lib/Screens/ProfileScreen.dart](../lib/Screens/ProfileScreen.dart)

### D) Home screen category → shape → product list

- `homeScreen` (in [lib/Screens/HomeScreen.dart](../lib/Screens/HomeScreen.dart))
  - AppBar **profile icon** → `Navigator.pushNamed("/profile")` → opens `MainNavScreen(initialIndex: 3)` (Profile tab)
  - AppBar **favorites icon** → `Navigator.pushNamed("/favorites")` → opens `FavoritesScreen` in [lib/Screens/FavoritesScreen.dart](../lib/Screens/FavoritesScreen.dart)
  - AppBar **cart icon** → `Navigator.pushNamed("/cart")` → opens `MainNavScreen(initialIndex: 2)` (Cart tab)
  - Tap on a category tile (Men/Women/Kids under Eyeglasses/Sunglasses) → opens **shape picker bottom sheet** `ShapePickerSheet` in [lib/Screens/shared/shape_picker_sheet.dart](../lib/Screens/shared/shape_picker_sheet.dart)

- `ShapePickerSheet` (in [lib/Screens/shared/shape_picker_sheet.dart](../lib/Screens/shared/shape_picker_sheet.dart))
  - Tap a shape (Square/Rectangle/Aviator/Geometric) → closes the bottom sheet and pushes:
    - `ShapeProductsScreen(categoryTitle, imageAsset, shape)` in [lib/Screens/ShapeProductsScreen.dart](../lib/Screens/ShapeProductsScreen.dart)

### E) Shape product list → Product details

- `ShapeProductsScreen` (in [lib/Screens/ShapeProductsScreen.dart](../lib/Screens/ShapeProductsScreen.dart))
  - Tap a product card → `Navigator.push(MaterialPageRoute(...))` → opens `ProductDetailsScreen` in [lib/Screens/ProductDetailsScreen.dart](../lib/Screens/ProductDetailsScreen.dart)

### F) Product details → Cart / Orders

- `ProductDetailsScreen` (in [lib/Screens/ProductDetailsScreen.dart](../lib/Screens/ProductDetailsScreen.dart))
  - Tap **cart icon** → `Navigator.pushNamed("/cart")` → opens `MainNavScreen(initialIndex: 2)` (Cart tab)
  - Tap **Buy Now** → places order in memory, then `Navigator.pushNamed("/orders")` → opens `MainNavScreen(initialIndex: 1)` (Orders tab)

### G) Profile (buyer vs seller)

- `ProfileScreen` (in [lib/Screens/ProfileScreen.dart](../lib/Screens/ProfileScreen.dart))

Buyer mode:
- Tap **Orders** list tile:
  - If inside `MainNavScreen`, it uses `MainNavScope.goToTab(1)` → switches to Orders tab without route push.
  - Otherwise it does `Navigator.pushNamed("/orders")` → opens Orders tab via route.

Seller mode:
- Tap **Add** button → pushes `SellerAddProductScreen` in [lib/Screens/SellerAddProductScreen.dart](../lib/Screens/SellerAddProductScreen.dart)
- Tap **edit (pencil)** icon on a product → pushes `SellerAddProductScreen.edit(existing: …)` in [lib/Screens/SellerAddProductScreen.dart](../lib/Screens/SellerAddProductScreen.dart)
- Tap **view (eye)** icon on a product → pushes `ProductDetailsScreen` in [lib/Screens/ProductDetailsScreen.dart](../lib/Screens/ProductDetailsScreen.dart)
- Tap **delete** icon → deletes from `ProductController` (no navigation)

Common:
- Tap **LOGOUT** → `Navigator.pushNamedAndRemoveUntil("/login", (route) => false)` → opens login and clears backstack.

### H) Legacy men/women/kids category screens (direct shape tiles)

These screens are still present and use direct `Navigator.push(MaterialPageRoute(...))` to `ShapeProductsScreen`:

- Eyeglasses:
  - Men: `EyeglassMen` in [lib/Screens/EyeGlasses/EyglassesMen.dart](../lib/Screens/EyeGlasses/EyglassesMen.dart)
  - Women: `EyeglassWomen` in [lib/Screens/EyeGlasses/EyglassesWomen.dart](../lib/Screens/EyeGlasses/EyglassesWomen.dart)
  - Kids: `EyeglassKids` in [lib/Screens/EyeGlasses/EyglassesKids.dart](../lib/Screens/EyeGlasses/EyglassesKids.dart)

- Sunglasses:
  - Men: `SunglassMen` in [lib/Screens/SunGlasses/SunglassesMen.dart](../lib/Screens/SunGlasses/SunglassesMen.dart)
  - Women: `SunglassWomen` in [lib/Screens/SunGlasses/SunglassesWomen.dart](../lib/Screens/SunGlasses/SunglassesWomen.dart)
  - Kids: `SunglassKids` in [lib/Screens/SunGlasses/SunglassesKids.dart](../lib/Screens/SunGlasses/SunglassesKids.dart)

### I) Purchase sheet (if/where used)

- `FramePurchaseSheet` (in [lib/Screens/PurchaseSheets/shared/frame_purchase_sheet.dart](../lib/Screens/PurchaseSheets/shared/frame_purchase_sheet.dart))
  - Tap **Add to Cart** → adds to cart, then `Navigator.pop()` (closes sheet)
  - Tap **Buy Now** → places order, then closes sheet and `pushNamed("/orders")`

---

## 4) Quick responsiveness summary

- Keyboard-safe (uses `MediaQuery.viewInsets.bottom`):
  - `loginScreen`, `signUpScreen`, `FramePurchaseSheet`
- Image aspect ratio safety:
  - `ProductDetailsScreen` uses `AspectRatio(16/10)`
- Not adaptive on tablets / large screens (fixed tile sizes / fixed grid count):
  - Most category tiles use fixed `height/width` and `GridView` uses `crossAxisCount: 2`.

If you want, I can update the grid/tile sizing to be adaptive (e.g., change crossAxisCount based on width) without changing your UX flow.
