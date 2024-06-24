# ShoesHub: A Complete Footwear Store Solution

ShoesHub is a comprehensive Flutter application designed for footwear stores. It consists of two separate apps: one for clients and one for admins. This setup ensures a seamless shopping experience for users while providing admins with robust tools to manage the store's inventory and orders.

## Client App Features

### Key Features:
- **Browse Products:** Clients can easily browse through a wide range of footwear products available in the store.
- **Product Details:** Each product has a detailed screen providing all necessary information, including images, descriptions, prices, and more.
- **Stripe Integration:** Clients can purchase products securely using Stripe, ensuring safe and hassle-free transactions.
- **User Registration:** Users can register an account with their email and phone number.
- **Password Reset:** Users can reset their password by receiving a reset link in their email via Firebase.
<hr>

[See Videos](#videos-for-app)


<hr>
 # 📱 Screens And Video 🎥

|  App Icon | Splash Screen |
|---------|---------|
| ![app_icon](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/49125895-7e99-4acb-a620-4fd2149b75ac)| ![splash_screen](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/59311bb7-2988-4ebd-b911-586c8e4d04cf)|

---

### Registration Module

**Registration Screen:** Enables users to sign up with their email, phone number, and password.  
**Phone Verification:** During registration, users verify their phone number using an OTP sent via Firebase.

|  Login Screen | Register Screen | Verify Phone |
|---------|---------|---------|
| ![login](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/f5280f21-a38a-47fa-bb68-07574c74c297)|![register](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/1b468294-1d96-4b76-9f55-fbfee7c5219e)|![verify_phone](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/cb8775b1-8743-44f6-a571-155266f5a3ff)|

### Home Module

**Home Screen:** Displays a list of products with search and filter options.  
**Real-time Updates:** Products are updated in real-time, eliminating the need for users to refresh the product list.

|  Home Screen | Category View | Brand View |
|---------|---------|---------|
| ![home_screen](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/e4307113-840b-43ea-9cff-c7bde75e5e7d)|![category](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/6fefa702-d6a5-4dda-a4c0-23993d249e47)|![filter_products](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/8831dbf4-d1f4-455f-8e61-6c2f49986a29)|

### Payment Stripe

|  Product Details Screen | Saved Card | Add Card View |
|---------|---------|---------|
| ![product_details](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/5bc18b2c-2ee0-4c22-9d84-4b752a4bb424)|![save_card](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/f0c27ff2-d4ac-4cb2-9a83-fc0462ac75bc)|![buy_product](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/1b894921-efea-4ea8-9f15-218d6fed30ff)|

---

## Admin App Features

The ShoesHub Admin App is a powerful tool designed for administrators to efficiently manage the footwear store's inventory and orders. Built with Flutter, this app provides real-time updates and an intuitive interface to ensure smooth operations.

### Key Features

- **Order Management:** View all orders placed by clients, including detailed information such as customer details, order status, and transaction IDs.
- **Product Management:** Add, edit, and remove products from the store inventory, with changes reflected in real-time in the client app.
- **Real-time Updates:** All modifications made by admins are instantly updated in the client app, ensuring clients always see the latest product information without needing to refresh.
- **Secure Access:** Admins can securely log in to the app to manage store operations, ensuring only authorized personnel can make changes.

### Screens

1. **Dashboard Screen:**
   - Overview of store activities.
   - Recent orders and inventory status.

2. **Order Details Screen:**
   - Detailed information about each order.
   - Customer details, order status, and transaction IDs.

3. **Product List Screen:**
   - List of all products with options to add, edit, or delete products.
   - Search and filter options for easy navigation.

4. **Product Edit Screen:**
   - Edit product details or add new products to the inventory.
   - Fields for product name, category, brand, price, description, and image URL.

|  Home Screen | Edit Product |
|---------|---------|
| ![admin_home](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/a675c84b-8dbf-431c-bb10-d5599875b50d)|![edit_order](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/c2977dba-a159-416d-8ae6-f8406f735ca4)|

|  Add Product | Upload Product Image |
|---------|---------|
| ![add_product](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/5830c6a0-46a2-4ed6-9dcd-f037cef1280f)|![upload_image](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/62eb0caa-d7a2-46dd-9372-d7455158e973)|

|  Orders Screen | No Orders |
|---------|---------|
| ![orders](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/ae39bfc4-1b2b-4d5b-8827-c4a7e173dfb3)|![no_order](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/4e806e73-9141-4e55-b0ac-0ab487e7ef50)|

|  Shipped Orders Screen |  Order Details |
|---------|---------|
| ![image3](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/d6c46f3b-f8a0-4c0f-ae40-97585e5b2840)|![order_details](https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/9bc8841a-abdf-4a1f-81df-a321a625efa9)|

### Usage

#### Managing Orders:
- Navigate to the Orders section from the dashboard.
- View all orders with detailed information.
- Update order status as needed.

#### Managing Products:
- Navigate to the Products section from the dashboard.
- Add new products by filling in the required details.
- Edit existing products to update their information.
- Remove products that are no longer available.

## Installation and Setup

To get started with ShoesHub, follow these steps:

1. **Clone the repository:**
   ```sh
   git clone https://github.com/AhmedBelal31/shoesHub.git
   cd shoesHub
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

4. **Set up Firebase:**
   - Add your Firebase project configuration files to both the client and admin apps.
   - Ensure Firebase Authentication and Firestore are enabled in your Firebase project.

## Videos For App

# Register Account 

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/8c3b03d3-20f4-43b4-968f-7690e25d010a


# Login , Verify Account 

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/6f321ff9-b466-4525-b674-70c6ffeb29cb


# Save Login , Shared Preference

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/c4496828-c18c-4bef-826c-c4aed64c2863


# Reset Password

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/fe4fc5c1-2642-4f61-8772-49e92c6d7cbf

# Home , Filter By Price , Category And Brand 

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/437e6c4e-b95c-4291-8345-b987213dc8f9


# Real-Time Update Of Products Status 

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/83228213-06b2-4ad5-ab7d-bb0ef9ef6663


# Buy Order

https://github.com/AhmedBelal31/Footwear-Store-Client/assets/131663660/495b1c85-8d97-4f03-b914-d1dc0357707d

## Installation and Setup

To get started with ShoesHub, follow these steps:

1. **Clone the repository:**
   ```sh
   git clone https://github.com/AhmedBelal31/shoesHub.git](https://github.com/AhmedBelal31/Footwear-Store-Client)
   cd shoesHub
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

4. **Set up Firebase:**
   - Add your Firebase project configuration files to both the client and admin apps.
   - Ensure Firebase Authentication and Firestore are enabled in your Firebase project.
