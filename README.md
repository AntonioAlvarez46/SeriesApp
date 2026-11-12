
# SeriesApp

App de iOS en SwiftUI para buscar series y ver su detalle. Pone el foco en la arquitectura, la concurrencia (cancelación), la caché y los tests.

## API pública: TVMaze

Uso la [API de TVMaze](https://www.tvmaze.com/api), que es gratuita y **no necesita API key**: basta con clonar el repo y ejecutarlo.

| Servicio | Endpoint |
|---|---|
| Búsqueda | `GET https://api.tvmaze.com/search/shows?q={query}` |
| Detalle | `GET https://api.tvmaze.com/shows/{id}` |

La API tiene un límite aproximado de 20 peticiones cada 10 segundos por IP. La caché y el debounce ayudan a no acercarse a ese límite.

## Cómo ejecutar

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/AntonioAlvarez46/SeriesApp.git
   ```
2. Abrir `SeriesApp.xcodeproj` con **Xcode 27** o superior.
3. Seleccionar un simulador de iPhone (iOS 17 o superior) y pulsar **⌘R**.
4. Tests: **⌘U**.

No hay dependencias externas: solo se usan frameworks de Apple.

## Arquitectura

Clean Architecture en tres capas, con **MVVM** en la capa de presentación:

```
Presentation  ──►  Domain  ◄──  Data
```

- **Domain**: entidad `Show`, el protocolo `ShowsRepository` y los casos de uso (`SearchShowsUseCase`, `GetShowDetailUseCase`). No depende de ninguna otra capa, ni de SwiftUI ni de la red.
- **Data**: implementa `ShowsRepository`. Contiene el cliente HTTP (`HTTPClient`), los endpoints, los DTOs, el mapper y la caché.
- **Presentation**: vistas de SwiftUI y ViewModels `@Observable` que solo hablan con los casos de uso.
- **App**: `AppContainer` crea las dependencias y las inyecta por inicializador. Hay una única instancia del repositorio y, por tanto, de la caché para toda la app.

Todas las dependencias se definen como protocolos, lo que permite sustituirlas por mocks en los tests.

## Decisiones principales

### Caché

- Es un `actor SearchCache` en memoria, que vive en la capa de Data, dentro del repositorio. El caso de uso no sabe si los datos vienen de caché o de red.
- Guarda una entrada por query con un **TTL de 5 minutos**.
- Si la entrada es válida, el repositorio devuelve los datos **sin llamar a la red**. Si ha expirado, la elimina, vuelve a pedir los datos a la red y actualiza la caché.
- Los errores no se cachean.
- El reloj se inyecta, así que los tests comprueban la expiración sin tener que esperar.
- Usar un `actor` garantiza el acceso exclusivo al diccionario y evita los *data races*.

### Cancelación

El `SearchViewModel` guarda el `Task` de la búsqueda en curso:

1. Cada vez que cambia el texto, **cancela la tarea anterior** y lanza una nueva.
2. Antes de buscar hay un **debounce de 400 ms** con `Task.sleep`. Si el usuario sigue escribiendo, la tarea se cancela durante esa espera y la petición nunca llega a salir.
3. La petición HTTP se hace con `URLSession` async/await, que **cancela la petición de red** cuando se cancela el `Task`.
4. Después de la respuesta, `guard !Task.isCancelled` asegura que **nunca se muestran resultados de una búsqueda anterior**.

En la pantalla de detalle, la carga se hace con `.task`, que se cancela automáticamente al salir de la pantalla.

## Tests

| Capa | Qué se prueba |
|---|---|
| **Domain** | `SearchShowsUseCase` con un repositorio mockeado: devuelve los resultados, hace trim de la query, no busca con texto vacío y propaga los errores. |
| **Data** | `DefaultShowsRepository` con `HTTPClient` y reloj mockeados: primera llamada a red, uso de la caché dentro del TTL, nueva llamada tras la expiración, queries distintas, normalización de la clave, errores no cacheados y mapeo de DTO a entidad. |
| **Presentation** | `SearchViewModel`: estados (idle, loaded, empty, error), cancelación de la búsqueda anterior sin mostrar resultados obsoletos, debounce y cancelación al borrar el texto. |
