# My_Diary_V2 📔

My_Diary_V2 es una aplicación móvil desarrollada en Flutter que funciona como un diario personal digital. Permite a los usuarios registrar pensamientos, emociones y notas del día a día, con la opción de adjuntar imágenes, marcar entradas favoritas y mantener su contenido privado mediante autenticación segura.

---

## 📸 Capturas de pantalla

![Image](https://github.com/user-attachments/assets/993d1029-1e77-4624-b042-edfccaa1723c)
![Image](https://github.com/user-attachments/assets/2935ebe4-c79c-4679-b282-c2e2cc2b0079)
![Image](https://github.com/user-attachments/assets/5a8ecd32-a03d-4f5a-8983-21e8c45e5ee1)
![Image](https://github.com/user-attachments/assets/6a65af05-199c-42b8-99e7-32243dd7392c)
![Image](https://github.com/user-attachments/assets/722f9cd6-e768-4be7-9e1b-9534eb0f4f81)
![Image](https://github.com/user-attachments/assets/21d71ae7-fac1-4036-965f-e2431e22b17f)
![Image](https://github.com/user-attachments/assets/99d017d3-92d2-4231-8c15-759e5be0a46e)
![Image](https://github.com/user-attachments/assets/789ec341-cb84-4a9e-9494-cb761717aa4f)
![Image](https://github.com/user-attachments/assets/434a53b1-9633-4882-a43d-d2f53057ba2d)
![Image](https://github.com/user-attachments/assets/a150b880-08bf-4e2e-a059-1c02c9496f8e)
![Image](https://github.com/user-attachments/assets/b3292f03-c2cc-4d94-bce4-a7e45d059c84)
![Image](https://github.com/user-attachments/assets/8c2f6dfd-d4eb-4a30-ba1b-8cea855baf5b)

---

## ✨ Características

- Registro e inicio de sesión con correo y contraseña
- Creación y edición de entradas estilo diario
- Subida de imágenes a Cloudinary
- Marcado de entradas favoritas
- Eliminación de notas
- Persistencia de sesión con SharedPreferences
- Navegación protegida según estado de autenticación

---

## 🛠 Tecnologías y herramientas utilizadas

- **Frontend:** Flutter
  - Gestión de estado con `Provider`
  - Consumo de APIs con `http`
  - Manejo de datos asincrónicos con `FutureBuilder`
  - Renderizado dinámico con `ListView.builder`
  - Persistencia local con `SharedPreferences`
- **Backend:** Node.js + Express
- **Base de datos:** MongoDB
- **Almacenamiento de imágenes:** Cloudinary

---

## 🚀 Instalación y ejecución

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tuusuario/My_Diary_V2.git
   ```
2. Abre el proyecto en tu editor de preferencia (como VS Code).
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Corre la app:
   ```bash
   flutter run
   ```

> **Nota:** Asegúrate de tener configurado tu backend (Node.js + MongoDB) y tus credenciales de Cloudinary. Reemplaza las URLs y claves necesarias en tu archivo de configuración.

---

## 📥 Descargar APK

Puedes probar la aplicación descargando el archivo `.apk` directamente desde aquí:

👉 [Descargar My_Diary_V2.apk](release/app-release.apk)


## 👤 Autor

**Miguel Jiménez**  
[migueljimenez1799@gmail.com]

---

## 📌 Estado del proyecto

- ✅ Versión funcional con autenticación, creación de notas, gestión de imágenes y favoritos.
- 🔧 Mejoras futuras previstas:
  - Optimización de la interfaz de usuario
  - Posible integración de recordatorios
  - Organización de entradas por categorías o etiquetas
