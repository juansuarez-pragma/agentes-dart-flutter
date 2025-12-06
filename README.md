# Sistema Multi-Agente df* para Dart/Flutter

Sistema de agentes especializados para desarrollo de proyectos Dart/Flutter siguiendo Clean Architecture, TDD estricto y mejores practicas del ecosistema.

## Proyectos

### DFSpec CLI

Herramienta CLI para Spec-Driven Development. Ver [dfspec/README.md](dfspec/README.md).

```bash
# Instalar
cd dfspec && dart pub global activate --source path .

# Uso rapido
dfspec init mi-proyecto
dfspec install --all
dfspec generate feature "Mi Feature"
```

## Descripcion

Este repositorio contiene 11 agentes especializados que trabajan de forma coordinada para:

- **Planificar** arquitectura y features con investigacion previa
- **Implementar** codigo siguiendo TDD estricto (Red-Green-Refactor)
- **Validar** calidad, seguridad, performance y documentacion
- **Verificar** completitud contra el plan original

## Agentes Disponibles

### Orquestador Central

| Agente | Comando | Descripcion |
|--------|---------|-------------|
| `dforchestrator` | `/df-orchestrate` | Punto de entrada. Clasifica solicitudes, coordina ejecucion |

### Agentes de Planificacion

| Agente | Comando | Descripcion |
|--------|---------|-------------|
| `dfplanner` | `/df-plan` | Arquitecto investigador. Disena planes verificables |

### Agentes de Validacion

| Agente | Comando | Descripcion |
|--------|---------|-------------|
| `dfsolid` | `/df-review` | Guardian de calidad. Audita SOLID, YAGNI, DRY |
| `dfsecurity` | `/df-security` | Guardian de seguridad. Audita OWASP Mobile Top 10 |
| `dfdependencies` | `/df-deps` | Guardian de dependencias. Valida paquetes en pub.dev |

### Agentes de Implementacion

| Agente | Comando | Descripcion |
|--------|---------|-------------|
| `dfimplementer` | `/df-implement` | Desarrollador TDD. Test → Codigo → Refactor |
| `dftest` | `/df-test` | Especialista QA. Unit, widget, integration tests |

### Agentes de Auditoria

| Agente | Comando | Descripcion |
|--------|---------|-------------|
| `dfcodequality` | `/df-quality` | Analista de metricas. Complejidad, code smells |
| `dfperformance` | `/df-performance` | Auditor de performance. Garantiza 60fps |
| `dfdocumentation` | `/df-docs` | Especialista en documentacion |
| `dfverifier` | `/df-verify` | Auditor de completitud vs especificacion |

## Pipeline Completo

Para implementar una feature nueva:

```
dfplanner (investiga y planifica)
    ↓
dfsolid (valida diseno)
    ↓
dfsecurity ←→ dfdependencies (validan en paralelo)
    ↓
dfimplementer (TDD: test → codigo → refactor)
    ↓
[CP_TDD] Checkpoint de correspondencia test-produccion
    ↓
dfdocumentation ←→ dfcodequality ←→ dfperformance (paralelo)
    ↓
dftest (validar cobertura)
    ↓
dfverifier (verificacion final)
```

## Flujo de Trabajo con DFSpec

```bash
# 1. Inicializar proyecto
dfspec init mi-proyecto

# 2. Instalar comandos slash
dfspec install --all

# 3. Crear especificacion
dfspec generate feature "Autenticacion OAuth"

# 4. En Claude Code, usar comandos slash:
/df-plan Autenticacion OAuth      # Planificar
/df-implement Autenticacion OAuth # Implementar con TDD
/df-verify Autenticacion OAuth    # Verificar
```

## Principios Fundamentales

### TDD Estricto

```
1. RED    → Escribir test que FALLA
2. GREEN  → Escribir codigo MINIMO para pasar
3. REFACTOR → Mejorar manteniendo tests verdes
```

### Clean Architecture

```
lib/src/
├── domain/      → Entidades, interfaces, usecases
├── data/        → Models, datasources, repository impl
├── presentation/→ UI, contracts, adapters
├── core/        → Concerns transversales
└── di/          → Inyeccion de dependencias
```

## Umbrales de Calidad

| Metrica | Objetivo |
|---------|----------|
| Cobertura de tests | >85% |
| Complejidad ciclomatica | <10 promedio |
| Complejidad cognitiva | <8 promedio |
| LOC por archivo | <400 |
| LOC por metodo | <40 |
| Frame budget (Flutter) | <16ms |

## Estructura del Repositorio

```
agents/
├── dfspec/                 # CLI para Spec-Driven Development
│   ├── lib/src/
│   │   ├── commands/       # Comandos CLI
│   │   ├── generators/     # Generadores de specs
│   │   ├── models/         # Modelos de datos
│   │   ├── templates/      # Templates de artefactos
│   │   └── utils/          # Utilidades
│   └── test/               # 121 tests
├── CLAUDE.md               # Guia para Claude Code
└── README.md               # Este archivo
```

## Herramientas MCP

Los agentes utilizan las siguientes herramientas MCP:

- `mcp__dart__analyze_files` - Analisis estatico
- `mcp__dart__run_tests` - Ejecutar tests
- `mcp__dart__dart_format` - Formatear codigo
- `mcp__dart__dart_fix` - Aplicar fixes automaticos
- `mcp__dart__pub` - Comandos pub (get, add, outdated)
- `mcp__dart__pub_dev_search` - Buscar paquetes en pub.dev

## Licencia

MIT License
