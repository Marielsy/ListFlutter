# Architecture Diagram

```mermaid
graph TD
    subgraph Presentation Layer
        UI[UI Widgets/Pages]
        Cubit[Cubit/Bloc]
    end

    subgraph Domain Layer
        UseCase[Use Cases]
        Entity[Entities]
        RepoInterface[Repository Interface]
    end

    subgraph Data Layer
        RepoImpl[Repository Implementation]
        RemoteDS[Remote Data Source]
        LocalDS[Local Data Source]
        Model[Models]
    end

    UI --> Cubit
    Cubit --> UseCase
    UseCase --> RepoInterface
    UseCase --> Entity
    RepoImpl ..|> RepoInterface
    RepoImpl --> RemoteDS
    RepoImpl --> LocalDS
    RepoImpl --> Model
    Model --|> Entity
```
