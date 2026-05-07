# High Performance Feed App

A highly optimized infinite-scrolling social feed built using Flutter, Riverpod, and Supabase.

This project focuses on:

* UI performance optimization
* GPU rendering optimization
* RAM-efficient image loading
* Optimistic UI state management
* Infinite scrolling architecture

---

# Tech Stack

* Flutter
* Riverpod
* Supabase
* Cached Network Image

---

# Features

## Infinite Scrolling Feed

* REST-based paginated feed loading
* Fetches 10 posts at a time
* Lazy rendering using `ListView.builder`


## GPU Optimization

* Heavy `BoxShadow` UI design
* Wrapped feed cards in `RepaintBoundary`
* Reduces unnecessary repaint operations during fast scrolling

## RAM Optimization

* Feed uses only low-resolution thumbnails
* Implemented `memCacheWidth` for memory-safe image decoding
* Prevents excessive RAM usage and OOM crashes

## Hero Animation

* Smooth transition between feed and detail screen
* Cached thumbnail shown instantly
* High-quality image fades in asynchronously

## Tiered Image Loading

Three-tier image architecture:

1. Thumbnail Image
2. Mobile Optimized Image
3. Raw High Resolution Image

## Optimistic UI

* Like button updates instantly
* Background Supabase RPC synchronization
* Offline revert support if request fails

## Offline Handling

* Graceful UI rollback on network failure
* Prevents inconsistent state

---

# Architecture

```text
UI Layer
↓
Riverpod Providers
↓
Service Layer
↓
Supabase Backend
```

---

# State Management

Riverpod is used for:

* Feed state
* Pagination state
* Loading/error states
* Optimistic like updates

`StateNotifierProvider` manages asynchronous feed updates and UI rebuilds.

---

# Performance Optimizations

## RepaintBoundary

Each complex feed card is wrapped inside `RepaintBoundary`.

Purpose:

* Isolates repaint regions
* Prevents expensive shadow recalculations
* Improves scrolling smoothness

---

## memCacheWidth

Images are loaded using `memCacheWidth`.

Purpose:

* Decode images near display size
* Reduce RAM consumption
* Prevent large bitmap memory usage

---

## Lazy Rendering

Used `ListView.builder` instead of rendering all widgets at once.

Purpose:

* Efficient memory usage
* Smooth infinite scrolling

---

# Supabase Backend

Supabase is used for:

* PostgreSQL database
* Storage bucket
* RPC functions

Database contains:

* posts table
* user_likes table

A concurrency-safe `toggle_like` RPC handles optimistic like synchronization safely.

---

# Folder Structure

```text
lib/
│
├── core/
├── models/
├── providers/
├── screens/
├── services/
├── widgets/
│
└── main.dart
```

---

# Setup Instructions

## 1. Clone Repository

```bash
git clone YOUR_REPOSITORY_URL
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Configure Supabase

Create:

```text
lib/core/supabase_config.dart
```

Add:

```dart
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

---

## 4. Run App

```bash
flutter run
```

---

# Testing Checklist

* Infinite scrolling
* Pull-to-refresh
* Hero animations
* Optimistic likes
* Offline revert handling
* Rapid scrolling performance
* Memory optimization

---

# Assignment Requirements Covered

* Infinite scrolling
* Pagination
* Pull-to-refresh
* RepaintBoundary
* memCacheWidth
* Hero animations
* Tiered image loading
* Optimistic UI
* Supabase RPC syncing
* Offline revert handling

---

# Future Improvements

* Per-post debounce for likes
* Real file downloading
* Persistent offline caching
* Authentication system
* Bookmarking and comments

---

# Demo

The demo video showcases:

* Infinite scrolling
* Hero transition
* Optimistic likes
* Offline revert handling

---
