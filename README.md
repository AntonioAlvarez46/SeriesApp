SeriesApp
App de iOS en SwiftUI para buscar series y ver su detalle.
Pone el foco en la arquitectura, la concurrencia(cancelacion), la cache y los tests.

API publica: TVMaze
Uso la API de TVMaze, que es gratuita y no necesita API key, basta con clonar el repo y ejecutarlo.

Servicio:
Busqueda: GET https://api.tvmaze.com/search/shows?q={query}
Detalle: GET https://api.tvmaze.com/shows/{id}

la API tiene un limite aproximado de 20 peticiones cada 10 segundos por IP. La cache y el debounce ayudan a no acercarse a ese limite.

Como ejecutar

1. Clonar el repositorio:

git clone https://github.com/AntonioAlvarez46/SeriesApp.git
2. Abrir SeriesApp.xcodeproj con Xcode 27 o superior
3. Seleccionar un simulador de iPhone y pulsar Command + R
4. Tests: Command + U

No hay dependencias externas: solo se usan frameworks de Apple

Arquitectura
Clean Architecture en tres capas, con MVVM en la capa de presentacion:
- Domain: entidad Show, el protocolo ShowsRepository y los casos de uso(SearchShowsUseCase, GetShowDetailUseCase). No depende de ninguna otra capa, ni de SwiftUi ni de la red.
- Data: implementa ShowsRepository. Contiene el cliente HTTP(HTTPClient), los endpoints, los DTOs, el mapper y la cache.
- Presentation: vistas de SwiftUI y ViewModels @Observable que solo hablan con los casos de uso.
- App: AppContainer crea las dependencias y las inyecta por inicializador. hay una unica instancia del repositorio y por tanto de la cache para toda la app.

Todas las dependencias se definen como protocolos, lo que permite sustituirlas por mocks en los tests.

Decisiones principales
Cache
- Es un actor SearchCache en memoria, que vive en la capa de Data, dentro del repositorio. El caso de uso no sabe si los datos vienen de cache o de red.
- Guarda una entrada por query con un TTL de 5 minutos.
- Si la entrada es valida el repositorio devuelve los datos sin llamar a la red. Si ha expirado, la elimina y vuelve a pedir los datos de red y actualiza la cache.
- Los errores no se cachean
- El reloj se inyecta, asi que los tests comprueban la expiracion sin tener que esperar
- Usar un actor garantiza el acceso exclusivo al diccionario y evita la data races

Cancelacion
El SearchViewModel guarda el Task de la busqueda en curso
1. Cada vez que cambia el texto cancela la tarea anterior y lanza una nueva
2. Antes de buscar hay un debounce de 400ms con Task.sleep. Si el usuario sigue escribiendo, la tarea se cancela durante esa espera y la peticion nunca llega a salir.
3. La peticion HTTP se hace con URLSession async/await que cancela la peticion de red cuando se cancela el Task.
4. Despues de la respuesta, guard !Task.isCancelled asegura que nunca se muestran resultados de una busqueda anterior.

En la pantalla de detalle, la carga se hace con .task, que se cancela automaticamente al salir de la pantalla.

Tests
- Domain: SearchShowsUseCase con un repositorio mockeado, devuelve los resultados, hace trim de la query, no busca con texto vacio y propaga los errores.
- Data: DefaultShowsRepository con HTTPClient y reloj mockeados: primera llamada a red, uso de la cache dentro del TTL, nueva llamada tras la expiracion, queries distintas, normalizacion de la clave, errores no cacheados y mapeo de DTO a entidad.
- Presentation: SearchViewModel, estados(idle, loaded, empty, error), cancelacion de la busqueda anterior sin mostrar resultados obsoletos, debounce y cancelacion al borrar el texto.


