# Feature Scaffolding (Mason)

## Mental Model

A feature is a module boundary. Pages are what you add to it over time.
Three atomic bricks map to Clean Architecture layers — run them independently, in any order, as the feature grows.

```
make-domain       → domain layer (entity + repository interface)
make-data         → data layer  (model + datasource + repo impl + providers)
make-presentation → presentation layer (page + notifier + route)
```

For full CRUD known upfront, use the shortcut:
```
make-feature      → chains: make-domain + make-data + make-presentation(list) + make-presentation(detail)
```

---

## `melos make-domain`

```sh
melos make-domain -- --name <feature_name> --app_package template_vgv_app
```

**Generates:**
```
lib/features/{name}/domain/
├── entities/{name}_entity.dart         (Freezed, id: int)
└── repositories/{name}_repository.dart (abstract interface, Either<Failure, T>)
```

**Hook:** runs `build_runner` (Freezed)

**Tests:** none — pure contracts, no behavior to test.

**When:** first step for any feature that owns API resources. Can be run alone when designing the domain before implementation begins.

---

## `melos make-data`

```sh
melos make-data -- --name <feature_name> --app_package template_vgv_app
```

**Generates:**
```
lib/features/{name}/data/
├── datasources/remote_{name}_datasource.dart   (Retrofit @RestApi)
├── models/{name}_model.dart                     (Freezed + @JsonSerializable)
└── repositories/{name}_repository_impl.dart    (RepositoryGuard mixin)
lib/features/{name}/{name}_providers.dart        (datasource + repo providers)

test/features/{name}/data/repositories/
└── {name}_repository_impl_test.dart
```

**Hook:** runs `build_runner` (Freezed + json_serializable + Retrofit + Riverpod)

**Tests generated:** `repository_impl_test.dart` — mocks datasource, tests success case (entity returned) and failure case (Failure returned).

**Requires:** `make-domain` run first (imports entity + repository interface).

---

## `melos make-presentation`

```sh
melos make-presentation -- --feature <feature_name> --name <page_name> --type <type> --app_package template_vgv_app
```

`--feature` is the feature folder the page belongs to. `--name` is the page name (can differ from feature). `--type` determines what gets generated.

---

### `--type list`

Paginated list screen. Uses `PaginatedListPage` + `PaginatedMixin`.

```
lib/features/{feature}/presentation/
├── pages/{name}_page.dart          (PaginatedListPage<{Feature}Entity>)
├── providers/{name}_notifier.dart  (AsyncNotifier + PaginatedMixin, fetchPage stub)
└── widgets/{name}_card.dart        (card widget stub)

test/features/{feature}/presentation/providers/
└── {name}_notifier_test.dart
```

Route registered: `/{name}`

**Requires:** `make-domain` + `make-data` run first.

---

### `--type detail`

Single-entity screen fetched by ID. Uses `AsyncDetailScaffold`.

```
lib/features/{feature}/presentation/
├── pages/{name}_page.dart          (AsyncDetailScaffold<{Feature}Entity>)
└── providers/{name}_notifier.dart  (AsyncNotifier<{Feature}Entity>, fetches by int id)

test/features/{feature}/presentation/providers/
└── {name}_notifier_test.dart
```

Route registered: `/{feature}/:id` — nested under the list route if one exists, top-level otherwise.

**Requires:** `make-domain` + `make-data` run first.

---

### `--type single`

Singleton resource screen — one entity, no ID param (current user profile, active cart).

```
lib/features/{feature}/presentation/
├── pages/{name}_page.dart          (ConsumerWidget, AsyncValueWidget<{Feature}Entity>)
└── providers/{name}_notifier.dart  (AsyncNotifier<{Feature}Entity>)

test/features/{feature}/presentation/providers/
└── {name}_notifier_test.dart
```

Route registered: `/{name}`

**Requires:** `make-domain` + `make-data` run first.

---

### `--type static`

Screen with no data layer dependency — dashboard aggregating from other providers, settings, about, onboarding.

```
lib/features/{feature}/presentation/
└── pages/{name}_page.dart          (ConsumerWidget stub)
```

No notifier generated — wire your own `ref.watch` calls inside the page.

Route registered: `/{name}`

**Does NOT require** `make-domain` or `make-data`. Feature folder is created if it does not exist.

**Tests:** none — no isolated async logic to test.

---

## `melos make-feature` (CRUD shortcut)

```sh
melos make-feature -- --name <feature_name> --app_package template_vgv_app
```

Chains `make-domain` + `make-data` + `make-presentation --type list` + `make-presentation --type detail` in one shot. Use when the spec clearly calls for a paginated list + detail from the start.

---

## Typical Flows

**Full CRUD, known from spec:**
```sh
melos make-feature -- --name orders --app_package my_app
```

**Feature growing over sprints:**
```sh
# Sprint 1 — data layer + summary page
melos make-domain       -- --name products --app_package my_app
melos make-data         -- --name products --app_package my_app
melos make-presentation -- --feature products --name product_summary --type static --app_package my_app

# Sprint 2 — add list
melos make-presentation -- --feature products --name products_list --type list --app_package my_app

# Sprint 3 — add detail
melos make-presentation -- --feature products --name products_detail --type detail --app_package my_app
```

**No data layer (dashboard):**
```sh
melos make-presentation -- --feature dashboard --name dashboard --type static --app_package my_app
```

**Singleton resource (profile):**
```sh
melos make-domain       -- --name profile --app_package my_app
melos make-data         -- --name profile --app_package my_app
melos make-presentation -- --feature profile --name profile --type single --app_package my_app
```

---

## File Ownership

Each brick owns distinct files — no two bricks touch the same file. Running a brick a second time with the same args only produces duplicate files; Mason's `--on-conflict skip` handles this.

| Brick | Files owned |
|---|---|
| `make-domain` | `domain/entities/`, `domain/repositories/` |
| `make-data` | `data/`, `{name}_providers.dart`, `test/data/` |
| `make-presentation` | `presentation/pages/{name}_*`, `presentation/providers/{name}_*`, `presentation/widgets/{name}_*`, `test/presentation/{name}_*` |

---

## Steps After Scaffolding

After running any brick:

1. Add API fields to `{name}_model.dart` and `{name}_entity.dart`
2. Implement `toEntity()` in the model mapper extension
3. Implement `fetchPage()` / fetch method in the notifier
4. Run `melos check`

---

## PaginatedMixin (list type)

The list notifier extends `PaginatedMixin<T>` from `lib/core/common/paginated_mixin.dart`:

- `loadMore()` — appends next page, guards against double calls
- `refresh()` — resets to page 1
- `hasMore` — true while more pages exist

Implement only `fetchPage(int page)`.

---

## Common Mistakes

- Running `make-data` before `make-domain` — compile errors on missing entity import
- Using `make-feature` when only one page type is needed — generates pages you'll have to delete
- Using `--type list` or `--type detail` without having run `make-domain` + `make-data`
- Forgetting `--app_package` — mason uses the default which may not match the project
- Not running `build_runner` after adding fields to the model
- Wiring a route without a stable `routeName` — Analytics reports raw paths instead of screen names
