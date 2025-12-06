# Sistema Multi-Agente df* para Dart/Flutter

Sistema de agentes especializados para desarrollo de proyectos Dart/Flutter siguiendo Clean Architecture, TDD estricto y mejores practicas del ecosistema.

## Descripcion

Este repositorio contiene 11 agentes especializados que trabajan de forma coordinada para:

- **Planificar** arquitectura y features con investigacion previa
- **Implementar** codigo siguiendo TDD estricto (Red-Green-Refactor)
- **Validar** calidad, seguridad, performance y documentacion
- **Verificar** completitud contra el plan original

## Agentes Disponibles

### Orquestador Central

| Agente | Descripcion |
|--------|-------------|
| `dforchestrator` | Punto de entrada. Clasifica solicitudes, decide recursos (MCP/agentes), coordina ejecucion en modos secuencial, paralelo o hibrido |

### Agentes de Planificacion

| Agente | Descripcion |
|--------|-------------|
| `dfplanner` | Arquitecto investigador. Explora codebase, consulta mejores practicas, disena planes verificables con criterios de aceptacion |

### Agentes de Validacion

| Agente | Descripcion |
|--------|-------------|
| `dfsolid` | Guardian de calidad. Audita SOLID, YAGNI, DRY y anti-patterns especificos de Flutter |
| `dfsecurity` | Guardian de seguridad. Audita OWASP Mobile Top 10, Platform Channels, WebView, deep linking |
| `dfdependencies` | Guardian de dependencias. Previene slopsquatting, valida paquetes en pub.dev, detecta APIs deprecadas |

### Agentes de Implementacion

| Agente | Descripcion |
|--------|-------------|
| `dfimplementer` | Desarrollador TDD. Escribe tests ANTES del codigo, implementa minimo para pasar, refactoriza |
| `dftest` | Especialista QA. Disena e implementa unit, widget, integration, E2E y golden tests |

### Agentes de Auditoria

| Agente | Descripcion |
|--------|-------------|
| `dfcodequality` | Analista de metricas. Mide complejidad ciclomatica/cognitiva, detecta code smells |
| `dfperformance` | Auditor de performance. Garantiza 60fps, detecta rebuilds innecesarios, memory leaks |
| `dfdocumentation` | Especialista en docs. Audita Effective Dart, detecta rotting comments, valida README |
| `dfverifier` | Auditor de completitud. Verifica implementacion vs plan, valida criterios de aceptacion |

## Modos de Ejecucion

El orquestador puede ejecutar en diferentes modos segun la solicitud:

```
MCP_ONLY      → Operacion directa sin razonamiento (ejecutar tests, formatear)
AGENT_SINGLE  → Un agente especializado resuelve la tarea
HYBRID        → Agente + MCPs combinados
PIPELINE      → Multiples agentes en secuencia coordinada
```

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

### Manejo de Errores

- Usar `Either<Failure, T>` de dartz para errores esperados
- Entidades inmutables con Equatable
- Tests con patron AAA y nombres en espanol

## Checkpoints y Recovery

El sistema mantiene checkpoints para recuperacion:

| Checkpoint | Despues de | Contenido |
|------------|------------|-----------|
| CP_PLAN | dfplanner | Plan, criterios, arquitectura |
| CP_DESIGN | dfsolid | Validacion SOLID, decisiones |
| CP_SECURITY | dfsecurity | Reporte OWASP, vulnerabilidades |
| CP_TDD | dfimplementer | Correspondencia 1:1 test-produccion |
| CP_QUALITY | agentes calidad | Metricas, issues |
| CP_TEST | dftest | Resultados, cobertura |

## Umbrales de Calidad

| Metrica | Objetivo |
|---------|----------|
| Cobertura de tests | >85% |
| Complejidad ciclomatica | <10 promedio |
| Complejidad cognitiva | <8 promedio |
| LOC por archivo | <400 |
| LOC por metodo | <40 |
| Frame budget (Flutter) | <16ms |

## Herramientas MCP

Los agentes utilizan las siguientes herramientas MCP:

- `mcp__dart__analyze_files` - Analisis estatico
- `mcp__dart__run_tests` - Ejecutar tests
- `mcp__dart__dart_format` - Formatear codigo
- `mcp__dart__dart_fix` - Aplicar fixes automaticos
- `mcp__dart__pub` - Comandos pub (get, add, outdated)
- `mcp__dart__pub_dev_search` - Buscar paquetes en pub.dev

## Uso

Los agentes estan disenados para ser invocados a traves de Claude Code. El orquestador (`dforchestrator`) es el punto de entrada recomendado que automaticamente selecciona y coordina los agentes apropiados.

### Ejemplos de Solicitudes

```
"Implementa un sistema de favoritos para productos"
→ Pipeline completo: dfplanner → dfsolid → ... → dfverifier

"Revisa la seguridad del modulo de autenticacion"
→ Agente unico: dfsecurity

"Ejecuta los tests"
→ MCP directo: mcp__dart__run_tests

"Ejecuta tests y arregla los que fallen"
→ Hibrido: mcp__dart__run_tests + dfimplementer
```

## Estructura del Repositorio

```
agents/
├── dforchestrator.md   # Orquestador central
├── dfplanner.md        # Arquitecto investigador
├── dfsolid.md          # Guardian SOLID/YAGNI/DRY
├── dfsecurity.md       # Guardian seguridad OWASP
├── dfdependencies.md   # Guardian dependencias
├── dfimplementer.md    # Desarrollador TDD
├── dfdocumentation.md  # Especialista documentacion
├── dfcodequality.md    # Analista metricas
├── dfperformance.md    # Auditor performance
├── dftest.md           # Especialista testing
├── dfverifier.md       # Auditor completitud
├── CLAUDE.md           # Guia para Claude Code
└── README.md           # Este archivo
```

## Licencia

Uso interno.
