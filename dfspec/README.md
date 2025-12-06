# DFSpec

**Spec-Driven Development para Flutter/Dart**

DFSpec es una herramienta CLI que implementa desarrollo guiado por especificaciones con agentes especializados y TDD estricto.

## Instalacion

```bash
# Desde pub.dev (proximamente)
dart pub global activate dfspec

# Desde fuente
git clone https://github.com/user/dfspec.git
cd dfspec
dart pub get
dart pub global activate --source path .
```

## Uso Rapido

```bash
# Inicializar proyecto
dfspec init mi-proyecto

# Instalar comandos slash para Claude Code
dfspec install --all

# Generar especificacion
dfspec generate feature "Autenticacion OAuth"

# Ver agentes disponibles
dfspec agents
```

## Comandos

### `dfspec init [nombre]`

Inicializa un proyecto con estructura DFSpec.

```bash
dfspec init                    # Usa nombre del directorio actual
dfspec init mi-app             # Nombre personalizado
dfspec init --minimal          # Solo estructura minima
dfspec init --force            # Reinicializa existente
```

Estructura creada:
```
proyecto/
├── dfspec.yaml              # Configuracion
├── specs/
│   ├── features/            # Especificaciones de features
│   ├── architecture/        # Decisiones arquitectonicas
│   ├── security/            # Requisitos de seguridad
│   └── performance/         # Requisitos de rendimiento
├── docs/
│   └── decisions/           # ADRs
└── .claude/
    └── commands/            # Comandos slash
```

### `dfspec install`

Instala comandos slash en `.claude/commands/`.

```bash
dfspec install                 # Instala esenciales
dfspec install --all           # Instala todos (13)
dfspec install --list          # Lista disponibles
dfspec install -c df-security  # Instala especifico
dfspec install --force         # Sobrescribe existentes
```

### `dfspec generate <tipo> <nombre>`

Genera archivos de especificacion desde templates.

```bash
dfspec generate feature "Login con Google"
dfspec generate architecture "Usar BLoC"
dfspec generate security "Modulo de Pagos"
dfspec generate performance "Lista de Productos"
dfspec generate api "REST API v1"
dfspec generate plan "Implementar Login"

dfspec gen --list              # Lista tipos disponibles
dfspec gen -t security "Auth"  # Con flag de tipo
dfspec gen -a "Juan" "Mi Spec" # Con autor
```

Tipos disponibles:
| Tipo | Descripcion |
|------|-------------|
| `feature` | Especificacion de funcionalidad |
| `architecture` | ADR - Decision de arquitectura |
| `security` | Analisis OWASP + STRIDE |
| `performance` | Metricas 60fps |
| `api` | Contrato de API REST |
| `plan` | Plan de implementacion TDD |

### `dfspec agents`

Lista y muestra informacion de agentes DFSpec.

```bash
dfspec agents                      # Lista todos
dfspec agents --info=dftest        # Info detallada
dfspec agents --category=quality   # Filtra categoria
dfspec agents --capability=TDD     # Busca por capacidad
dfspec agents --json               # Salida JSON
```

## Agentes Especializados

DFSpec incluye 11 agentes especializados:

| Agente | Comando | Funcion |
|--------|---------|---------|
| dforchestrator | `/df-orchestrate` | Coordinacion de agentes |
| dfplanner | `/df-plan` | Planificacion y arquitectura |
| dfimplementer | `/df-implement` | Implementacion TDD |
| dftest | `/df-test` | Testing y cobertura |
| dfsolid | `/df-review` | Revision SOLID |
| dfsecurity | `/df-security` | Seguridad OWASP |
| dfdependencies | `/df-deps` | Gestion dependencias |
| dfcodequality | `/df-quality` | Linting estricto |
| dfperformance | `/df-performance` | Optimizacion 60fps |
| dfdocumentation | `/df-docs` | Documentacion |
| dfverifier | `/df-verify` | Verificacion vs spec |

## Comandos Slash

13 comandos slash para Claude Code:

```
/df-spec        - Crear/analizar especificaciones
/df-plan        - Generar plan de implementacion
/df-implement   - Implementar con TDD
/df-test        - Generar y ejecutar tests
/df-review      - Revision SOLID
/df-security    - Analisis OWASP
/df-performance - Optimizacion 60fps
/df-docs        - Generar documentacion
/df-verify      - Verificar vs spec
/df-status      - Estado del proyecto
/df-orchestrate - Orquestar agentes
/df-deps        - Gestionar dependencias
/df-quality     - Analisis de calidad
```

## Flujo de Trabajo

```
1. Crear especificacion
   dfspec generate feature "Mi Feature"

2. Revisar y completar spec
   Editar specs/features/mi-feature.feature.md

3. Generar plan
   /df-plan Mi Feature

4. Implementar con TDD
   /df-implement Mi Feature

5. Verificar
   /df-verify Mi Feature
```

## Configuracion

`dfspec.yaml`:

```yaml
# Configuracion DFSpec
project_name: mi-proyecto

# Directorios
spec_dir: specs
output_dir: .claude/commands
template_dir: templates

# Agentes habilitados
agents:
  - dforchestrator
  - dfplanner
  - dfimplementer
  - dftest
  - dfverifier
```

## Desarrollo

```bash
# Clonar
git clone https://github.com/user/dfspec.git
cd dfspec

# Dependencias
dart pub get

# Tests
dart test

# Analisis
dart analyze

# Ejecutar
dart run bin/dfspec.dart --help
```

## Licencia

MIT License - Ver [LICENSE](LICENSE)
