# DFSpec

**Spec-Driven Development para Flutter/Dart**

[![Dart](https://img.shields.io/badge/Dart-%5E3.10.1-blue)](https://dart.dev)
[![Tests](https://img.shields.io/badge/tests-121%20passing-green)](test/)
[![Analysis](https://img.shields.io/badge/analysis-0%20issues-green)](analysis_options.yaml)

DFSpec es una herramienta que implementa desarrollo guiado por especificaciones con agentes especializados y TDD estricto.

## Modos de Uso

DFSpec ofrece **dos modos de uso independientes**:

| Modo | Descripcion | Instalacion | Alcance |
|------|-------------|-------------|---------|
| **Slash Commands** | Comandos dentro de Claude Code | Solo clonar repo | Local a la sesion |
| **CLI Global** | Comandos desde cualquier terminal | Activacion global | Todo el sistema |

### Modo 1: Slash Commands en Claude Code (Recomendado)

Este modo **NO requiere instalacion global**. Los comandos funcionan dentro de Claude Code y no modifican tu sistema.

```bash
# 1. Clonar el repositorio
git clone https://github.com/juansuarez-pragma/agentes-dart-flutter.git

# 2. Abrir Claude Code en el directorio dfspec
cd agentes-dart-flutter/dfspec
claude  # o abrir con tu IDE

# 3. Usar los slash commands directamente
/df-spec mi-feature
/df-plan mi-feature
/df-implement mi-feature
```

**Caracteristicas:**
- No modifica el sistema del usuario
- Comandos disponibles solo dentro de Claude Code
- Funciona inmediatamente despues de clonar
- Los comandos estan en `.claude/commands/`

### Modo 2: CLI Global (Opcional)

Este modo instala `dfspec` como comando global en tu sistema. **Modifica tu equipo** agregando ejecutables al PATH.

```bash
# 1. Clonar e instalar
git clone https://github.com/juansuarez-pragma/agentes-dart-flutter.git
cd agentes-dart-flutter/dfspec
dart pub get

# 2. Activar globalmente (MODIFICA TU SISTEMA)
dart pub global activate --source path .

# 3. Verificar instalacion
dfspec --version

# Para desinstalar:
dart pub global deactivate dfspec
```

**Que hace la activacion global:**
- Instala el ejecutable en `~/.pub-cache/bin/dfspec`
- Agrega symlink al PATH de Dart
- Permite usar `dfspec` desde cualquier directorio
- Persiste despues de cerrar la terminal

**Cuando usar CLI global:**
- Quieres usar `dfspec init`, `dfspec generate` desde terminal
- Necesitas integrar con scripts de CI/CD
- Prefieres terminal sobre Claude Code

## Caracteristicas

- **4 comandos CLI**: `init`, `install`, `generate`, `agents`
- **13 comandos slash** para Claude Code
- **6 tipos de especificacion**: feature, architecture, security, performance, api, plan
- **11 agentes especializados** para desarrollo Flutter/Dart
- **121 tests** con cobertura ~85%
- **Linting estricto** con very_good_analysis

## Uso Rapido con Slash Commands

```bash
# Flujo completo dentro de Claude Code:

/df-spec mi-feature          # Crear especificacion
/df-plan mi-feature          # Generar plan de implementacion
/df-implement mi-feature     # Implementar con TDD
/df-verify mi-feature        # Verificar contra spec
/df-status                   # Ver estado del proyecto
```

## Comandos CLI (Modo Global)

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

| Comando | Descripcion |
|---------|-------------|
| `/df-spec` | Crear/analizar especificaciones |
| `/df-plan` | Generar plan de implementacion |
| `/df-implement` | Implementar con TDD |
| `/df-test` | Generar y ejecutar tests |
| `/df-review` | Revision SOLID |
| `/df-security` | Analisis OWASP |
| `/df-performance` | Optimizacion 60fps |
| `/df-docs` | Generar documentacion |
| `/df-verify` | Verificar vs spec |
| `/df-status` | Estado del proyecto |
| `/df-orchestrate` | Orquestar agentes |
| `/df-deps` | Gestionar dependencias |
| `/df-quality` | Analisis de calidad |

## Flujo de Trabajo Recomendado

```
1. Crear especificacion
   /df-spec mi-feature

2. Revisar y completar spec
   Editar docs/specs/features/mi-feature.spec.md

3. Generar plan
   /df-plan mi-feature

4. Implementar con TDD
   /df-implement mi-feature

5. Verificar
   /df-verify mi-feature
```

## Configuracion

`dfspec.yaml`:

```yaml
# Configuracion DFSpec
project:
  name: mi-proyecto
  type: flutter_app
  platforms:
    - web
    - android
    - ios
  state_management: riverpod
  path: /ruta/al/proyecto
  configured: true

directories:
  docs_dir: docs/specs

features:
  mi-feature:
    type: api_integration
    status: planned  # planned -> implemented -> verified
```

## Desarrollo

```bash
# Dependencias
dart pub get

# Tests
dart test

# Analisis
dart analyze

# Fix automatico
dart fix --apply

# Ejecutar localmente (sin instalar global)
dart run bin/dfspec.dart --help
```

## Estructura del Proyecto

```
dfspec/
├── bin/
│   └── dfspec.dart          # Entry point CLI
├── lib/
│   ├── dfspec.dart          # Library export
│   └── src/
│       ├── commands/        # Comandos CLI
│       ├── generators/      # Generadores de specs
│       ├── models/          # Modelos de datos
│       ├── templates/       # Templates de artefactos
│       └── utils/           # Utilidades
├── .claude/
│   └── commands/            # Slash commands (13 archivos .md)
├── test/                    # 121 tests
├── example/                 # Ejemplo de uso
├── analysis_options.yaml    # Linting config
└── pubspec.yaml             # Dependencias
```

## Calidad de Codigo

- **0 errores** en `dart analyze`
- **121 tests** pasando
- **Linting estricto** con very_good_analysis
- **Excepciones personalizadas** para error handling
- **Logger testeable** con inyeccion de dependencias
- **Clases inmutables** con `@immutable`

## Licencia

MIT License
